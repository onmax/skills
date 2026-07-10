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
  "codexRequest": null,
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

command='{"schema":1,"repository":"vite-hub/vitehub","number":525,"head":"abc123","commentId":1,"requestedAt":"2026-07-09T16:10:00Z"}'
quota='{"id":2,"body":"You have reached your Codex usage limits for code reviews.","createdAt":"2026-07-09T16:10:08Z","author":"chatgpt-codex-connector[bot]"}'
fallback='{"verdict":"no-major-issues","reason":"reviewed exact diff","head":"abc123","createdAt":"2026-07-09T16:11:00Z","observable":true}'
stale_fallback='{"verdict":"no-major-issues","head":"abc123","createdAt":"2026-07-09T16:09:00Z","observable":true}'
wrong_head_fallback='{"verdict":"no-major-issues","head":"def456","createdAt":"2026-07-09T16:11:00Z","observable":true}'
thumb='{"id":3,"content":"+1","createdAt":"2026-07-09T16:10:09Z","author":"chatgpt-codex-connector[bot]","commentId":1}'
review='{"id":5,"body":"No major issues found.","submittedAt":"2026-07-09T16:10:09Z","head":"abc123","author":"chatgpt-codex-connector[bot]","state":"COMMENTED"}'
needs_fix_review='{"id":6,"body":"The null guard is missing.","submittedAt":"2026-07-09T16:10:09Z","head":"abc123","author":"chatgpt-codex-connector[bot]","state":"COMMENTED"}'

run_case missing missing fallback-review '.'
run_case pending pending wait-review ".codexRequest = $command"
run_case timed_out unavailable fallback-review ".codexRequest = ($command + {requestedAt: \"2026-07-09T16:00:01Z\"}) | .policy.codexTimeoutSeconds = 600"
run_case quota unavailable fallback-review ".codexRequest = $command | .comments = [$quota]"
run_case quota_fallback unavailable merge ".codexRequest = $command | .comments = [$quota] | .fallback = $fallback"
run_case stale_fallback unavailable fallback-review ".codexRequest = $command | .comments = [$quota] | .fallback = $stale_fallback"
run_case wrong_head_fallback unavailable fallback-review ".codexRequest = $command | .comments = [$quota] | .fallback = $wrong_head_fallback"
run_case reviewed reviewed merge ".codexRequest = $command | .reactions = [$thumb]"
run_case wrong_target_reaction pending wait-review ".codexRequest = $command | .reactions = [($thumb + {commentId: 99})]"
run_case reviewed_body reviewed merge ".codexRequest = $command | .reviews = [$review]"
run_case newer_request pending wait-review ".codexRequest = ($command + {commentId: 4, requestedAt: \"2026-07-09T16:10:10Z\"}) | .comments = [$quota]"
run_case unbound_manual_command missing fallback-review '.comments = [{"id":7,"body":"@codex review","createdAt":"2026-07-09T16:10:00Z","author":"onmax"}]'
run_case equal_second_request pending wait-review ".codexRequest = ($command + {requestedAt: \"2026-07-09T16:00:00Z\"})"
run_case wrong_head_request missing fallback-review ".codexRequest = ($command + {head: \"def456\"})"
run_case comments_allowed missing request-review '.policy.comments = "allowed"'
run_case comments_allowed_pending_checks missing request-review '.policy.comments = "allowed" | .checks = [{"name":"ci","bucket":"pending"}]'
run_case comments_allowed_failed_checks missing repair '.policy.comments = "allowed" | .checks = [{"name":"ci","bucket":"fail"}]'
run_case comments_allowed_existing_fallback missing merge ".policy.comments = \"allowed\" | .fallback = $fallback"
run_case comments_allowed_existing_findings missing repair ".policy.comments = \"allowed\" | .fallback = ($fallback + {verdict: \"needs-fix\"})"
run_case quota_pending_checks unavailable fallback-review ".codexRequest = $command | .comments = [$quota] | .checks = [{\"name\":\"ci\",\"bucket\":\"pending\"}]"
run_case findings_pending_checks reviewed repair ".reviews = [$needs_fix_review] | .checks = [{\"name\":\"ci\",\"bucket\":\"pending\"}]"
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
run_case fallback_findings unavailable repair ".codexRequest = $command | .comments = [$quota] | .fallback = ($fallback + {verdict: \"needs-fix\"})"
run_case repair_disabled_findings unavailable wait-review-findings ".codexRequest = $command | .comments = [$quota] | .fallback = ($fallback + {verdict: \"needs-fix\"}) | .policy.repair = \"disabled\""
run_case fallback_inconclusive unavailable wait-review-inconclusive ".codexRequest = $command | .comments = [$quota] | .fallback = ($fallback + {verdict: \"inconclusive\"})"
run_case portal_blocked_reviewed reviewed ready-for-human-review ".codexRequest = $command | .reactions = [$thumb] | .policy.merge = \"disabled\" | .mergeState = \"BLOCKED\""
run_case vitehub_blocked_reviewed reviewed wait-merge-state ".codexRequest = $command | .reactions = [$thumb] | .mergeState = \"BLOCKED\""

portal_result="$(
  jq ".codexRequest = $command | .reactions = [$thumb] | .policy.merge = \"disabled\" | .mergeState = \"BLOCKED\"" "$tmp/base.json" \
    | "$skill_dir/scripts/pr-readiness.sh" --input /dev/stdin
)"
jq -e '.action == "ready-for-human-review" and .ready == true and (.blockers | length) == 0' \
  <<< "$portal_result" >/dev/null

finding_result="$(
  jq ".codexRequest = $command | .comments = [$quota] | .fallback = ($fallback + {verdict: \"needs-fix\", reason: \"missing null guard\"})" "$tmp/base.json" \
    | "$skill_dir/scripts/pr-readiness.sh" --input /dev/stdin
)"
jq -e '.action == "repair" and .fallback.reason == "missing null guard" and .blockers == ["review-needs-fix"]' \
  <<< "$finding_result" >/dev/null

echo "readiness fixtures passed"
