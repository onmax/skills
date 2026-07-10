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
  "title": "fix(agent): preserve data events",
  "draft": false,
  "mergeState": "CLEAN",
  "head": {"sha": "abc123", "committedAt": "2026-07-09T16:00:00Z"},
  "policy": {"merge": "allowed", "comments": "disabled", "checks": "all-visible"},
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
fallback='{"verdict":"no-major-issues","head":"abc123","createdAt":"2026-07-09T16:11:00Z","observable":true}'
stale_fallback='{"verdict":"no-major-issues","head":"abc123","createdAt":"2026-07-09T16:09:00Z","observable":true}'
wrong_head_fallback='{"verdict":"no-major-issues","head":"def456","createdAt":"2026-07-09T16:11:00Z","observable":true}'
thumb='{"id":3,"content":"+1","createdAt":"2026-07-09T16:10:09Z","author":"chatgpt-codex-connector[bot]"}'
review='{"id":5,"body":"No major issues found.","submittedAt":"2026-07-09T16:10:09Z","head":"abc123","author":"chatgpt-codex-connector[bot]","state":"COMMENTED"}'

run_case missing missing fallback-review '.'
run_case pending pending wait-review ".comments = [$command]"
run_case quota unavailable fallback-review ".comments = [$command, $quota]"
run_case quota_fallback unavailable merge ".comments = [$command, $quota] | .fallback = $fallback"
run_case stale_fallback unavailable fallback-review ".comments = [$command, $quota] | .fallback = $stale_fallback"
run_case wrong_head_fallback unavailable fallback-review ".comments = [$command, $quota] | .fallback = $wrong_head_fallback"
run_case reviewed reviewed merge ".comments = [$command] | .reactions = [$thumb]"
run_case reviewed_body reviewed merge ".comments = [$command] | .reviews = [$review]"
run_case newer_command pending wait-review ".comments = [$quota, ($command + {id: 4, createdAt: \"2026-07-09T16:10:10Z\"})]"
run_case bot_quote missing fallback-review ".comments = [($command + {author: \"chatgpt-codex-connector[bot]\"})]"
run_case comments_allowed missing request-review '.policy.comments = "allowed"'
run_case head_changed missing head-changed '.collection.headAfter = "def456"'
run_case unresolved missing fix-feedback '.threads = [{"isResolved":false,"isOutdated":false}]'
run_case failed_check missing repair-checks '.checks = [{"name":"ci","bucket":"fail"}]'
run_case pending_check missing wait-checks '.checks = [{"name":"ci","bucket":"pending"}]'
run_case missing_checks missing wait-checks '.checks = []'

echo "readiness fixtures passed"
