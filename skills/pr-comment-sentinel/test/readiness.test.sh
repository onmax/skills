#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/base.json" <<'JSON'
{
  "schema": 1,
  "repository": "vite-hub/vitehub",
  "number": 525,
  "expectedHead": "abc123",
  "viewer": "onmax",
  "codexBot": "chatgpt-codex-connector[bot]",
  "author": "onmax",
  "createdAt": "2026-07-09T15:00:00Z",
  "title": "fix(agent): preserve data events",
  "draft": false,
  "mergeState": "CLEAN",
  "head": {"sha": "abc123", "committedAt": "2026-07-09T16:00:00Z"},
  "policy": {"merge": "allowed", "repair": "allowed", "comments": "disabled", "checks": "all-visible"},
  "checks": [{"name": "ci", "bucket": "pass"}],
  "threads": [],
  "comments": [],
  "reviews": [],
  "reactions": [],
  "fallback": null,
  "collection": {
    "startedAt": "2026-07-09T16:12:00Z",
    "finishedAt": "2026-07-09T16:12:01Z",
    "headAfter": "abc123"
  }
}
JSON

run_case() {
  local name="$1"
  local expected_lane="$2"
  local expected_action="$3"
  local filter="$4"
  local fixture="$tmp/$name.json"
  local result

  jq "$filter" "$tmp/base.json" > "$fixture"
  result="$($skill_dir/scripts/pr-readiness.sh --input "$fixture")"
  jq -e \
    --arg lane "$expected_lane" \
    --arg action "$expected_action" \
    '.codexLane.state == $lane and .action == $action' \
    <<< "$result" >/dev/null || {
      echo "case $name failed: expected lane=$expected_lane action=$expected_action" >&2
      jq . <<< "$result" >&2
      exit 1
    }
}

command='{"id":1,"body":"@codex review","createdAt":"2026-07-09T16:10:00Z","author":"onmax"}'
quota='{"id":2,"body":"You have reached your Codex usage limits for code reviews.","createdAt":"2026-07-09T16:10:08Z","author":"chatgpt-codex-connector[bot]"}'
fallback='{"verdict":"no-major-issues","reason":"reviewed exact diff","head":"abc123","createdAt":"2026-07-09T16:11:00Z","observable":true}'
stale_fallback='{"verdict":"no-major-issues","head":"abc123","createdAt":"2026-07-09T16:09:00Z","observable":true}'
wrong_head_fallback='{"verdict":"no-major-issues","head":"def456","createdAt":"2026-07-09T16:11:00Z","observable":true}'
thumb='{"id":3,"content":"+1","createdAt":"2026-07-09T16:10:09Z","author":"chatgpt-codex-connector[bot]"}'
review='{"id":5,"body":"No major issues found.","submittedAt":"2026-07-09T16:10:09Z","head":"abc123","author":"chatgpt-codex-connector[bot]","state":"COMMENTED"}'

run_case missing missing fallback-review '.'
run_case pending pending wait-review ".comments = [$command]"
run_case timed_out unavailable fallback-review ".comments = [($command + {createdAt: \"2026-07-09T16:00:01Z\"})] | .policy.codexTimeoutSeconds = 600"
run_case quota unavailable fallback-review ".comments = [$command, $quota]"
run_case quota_fallback unavailable merge ".comments = [$command, $quota] | .fallback = $fallback"
run_case stale_fallback unavailable fallback-review ".comments = [$command, $quota] | .fallback = $stale_fallback"
run_case wrong_head_fallback unavailable fallback-review ".comments = [$command, $quota] | .fallback = $wrong_head_fallback"
run_case reviewed reviewed merge ".comments = [$command] | .reactions = [$thumb]"
run_case reviewed_body reviewed merge ".comments = [$command] | .reviews = [$review]"
run_case newer_command pending wait-review ".comments = [$quota, ($command + {id: 4, createdAt: \"2026-07-09T16:10:10Z\"})]"
run_case bot_quote missing fallback-review ".comments = [($command + {author: \"chatgpt-codex-connector[bot]\"})]"
run_case comments_allowed missing fallback-review '.policy.comments = "allowed"'
run_case head_changed missing head-changed '.collection.headAfter = "def456"'
run_case grandfathered missing grandfathered '.policy.notBefore = "2026-07-09T17:00:00Z"'
run_case later_commit missing fallback-review '.policy.notBefore = "2026-07-09T15:30:00Z"'
run_case unresolved missing repair '.threads = [{"id":"thread-1","isResolved":false,"isOutdated":false}]'
run_case repair_disabled_feedback missing wait-feedback '.threads = [{"id":"thread-1","isResolved":false,"isOutdated":false}] | .policy.repair = "disabled"'
run_case failed_check missing repair '.checks = [{"name":"ci","bucket":"fail","link":"https://example.test/run/1","completedAt":"2026-07-09T16:12:00Z"}]'
run_case repair_disabled_check missing wait-checks '.checks = [{"name":"ci","bucket":"fail"}] | .policy.repair = "disabled"'
run_case no_merge_failed_check missing repair '.checks = [{"name":"ci","bucket":"fail"}] | .policy.merge = "disabled"'
run_case no_merge_dirty missing repair '.mergeState = "DIRTY" | .policy.merge = "disabled"'
run_case pending_check missing wait-checks '.checks = [{"name":"ci","bucket":"pending"}]'
run_case missing_checks missing wait-checks '.checks = []'
run_case fallback_findings unavailable repair ".comments = [$command, $quota] | .fallback = ($fallback + {verdict: \"needs-fix\"})"
run_case repair_disabled_findings unavailable wait-review-findings ".comments = [$command, $quota] | .fallback = ($fallback + {verdict: \"needs-fix\"}) | .policy.repair = \"disabled\""
run_case fallback_inconclusive unavailable wait-review-inconclusive ".comments = [$command, $quota] | .fallback = ($fallback + {verdict: \"inconclusive\"})"
run_case portal_blocked_reviewed reviewed ready-for-human-review ".comments = [$command] | .reactions = [$thumb] | .policy.merge = \"disabled\" | .mergeState = \"BLOCKED\""
run_case vitehub_blocked_reviewed reviewed wait-merge-state ".comments = [$command] | .reactions = [$thumb] | .mergeState = \"BLOCKED\""

portal_result="$(
  jq ".comments = [$command] | .reactions = [$thumb] | .policy.merge = \"disabled\" | .mergeState = \"BLOCKED\"" "$tmp/base.json" \
    | "$skill_dir/scripts/pr-readiness.sh" --input /dev/stdin
)"
jq -e '.action == "ready-for-human-review" and .ready == true and (.blockers | length) == 0' \
  <<< "$portal_result" >/dev/null

finding_result="$(
  jq ".comments = [$command, $quota] | .fallback = ($fallback + {verdict: \"needs-fix\", reason: \"missing null guard\"})" "$tmp/base.json" \
    | "$skill_dir/scripts/pr-readiness.sh" --input /dev/stdin
)"
jq -e '.action == "repair" and .fallback.reason == "missing null guard" and .blockers == ["review-needs-fix"]' \
  <<< "$finding_result" >/dev/null

echo "readiness fixtures passed"
