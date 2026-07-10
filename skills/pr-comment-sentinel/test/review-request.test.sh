#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/scripts"
cp "$skill_dir/scripts/run-heartbeat.sh" "$tmp/scripts/run-heartbeat.sh"
cp "$skill_dir/scripts/request-review.sh" "$tmp/scripts/request-review.sh"

snapshot='{"repository":"vite-hub/vitehub","number":532,"head":"abc123","viewer":"onmax","action":"request-review","blockers":["review-missing"],"policy":{"merge":"allowed","repair":"allowed","comments":"allowed","notBefore":""}}'

cat > "$tmp/scripts/heartbeat-state.sh" <<MOCK
#!/usr/bin/env bash
printf '%s\n' '$snapshot'
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<MOCK
#!/usr/bin/env bash
printf '%s\n' '$snapshot'
MOCK

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$GH_LOG"
if [ "$1" = "api" ]; then
  if [[ "$*" == *"--method POST"* ]]; then
    if [ -n "${GH_RESPONSE+x}" ]; then
      printf '%s\n' "$GH_RESPONSE"
    else
      printf '%s\n' '{"id":42,"created_at":"2026-07-10T06:30:00Z"}'
    fi
  else
    [ "${GH_COMMENTS_FAIL:-0}" != 1 ] || exit 1
    printf '%s\n' "${GH_COMMENTS_RESPONSE:-[]}"
  fi
elif [ "$1 $2" = "pr view" ]; then
  printf '%s\n' "${GH_HEAD:-abc123}"
fi
MOCK

chmod +x "$tmp/bin/gh" "$tmp/scripts"/*.sh

result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/gh.log" \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '
  .action == "request-review"
  and .result == "review-requested"
  and .blocker == ""
' <<< "$result" >/dev/null

diff -u \
  <(printf '%s\n' \
    'api --method POST repos/vite-hub/vitehub/issues/532/comments -f body=@codex review' \
    'pr view 532 --repo vite-hub/vitehub --json headRefOid --jq .headRefOid') \
  "$tmp/gh.log"

jq -e '
  .schema == 1
  and .phase == "posted"
  and .repository == "vite-hub/vitehub"
  and .number == 532
  and .head == "abc123"
  and .author == "onmax"
  and .commentId == 42
  and .requestedAt == "2026-07-10T06:30:00Z"
' "$tmp/workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123/codex-request.json" >/dev/null

changed_result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/changed-gh.log" \
  GH_HEAD=def456 \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/changed-workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '
  .action == "request-review"
  and .result == "review-requested-head-changed"
  and .blocker == ""
' <<< "$changed_result" >/dev/null

jq -e '.phase == "posted" and .head == "abc123" and .commentId == 42' \
  "$tmp/changed-workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123/codex-request.json" >/dev/null

invalid_result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/invalid-gh.log" \
  GH_RESPONSE='{}' \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/invalid-workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '
  .result == "review-failed"
  and .blocker == "review-request-invalid-response"
' <<< "$invalid_result" >/dev/null

jq -e '.phase == "intent" and .head == "abc123"' \
  "$tmp/invalid-workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123/codex-request.json" >/dev/null

recovery_dir="$tmp/recovery-workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123"
mkdir -p "$recovery_dir"
printf '%s\n' '{"schema":1,"phase":"intent","repository":"vite-hub/vitehub","number":532,"head":"abc123","author":"onmax","attemptedAt":"2026-07-10T06:29:59Z"}' \
  > "$recovery_dir/codex-request.json"

recovered_result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/recovered-gh.log" \
  GH_COMMENTS_RESPONSE='[{"id":43,"body":"@codex review","created_at":"2026-07-10T06:30:00Z","user":{"login":"onmax"}}]' \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/recovery-workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '.result == "review-recovered" and .blocker == ""' <<< "$recovered_result" >/dev/null
jq -e '.phase == "posted" and .head == "abc123" and .commentId == 43' \
  "$recovery_dir/codex-request.json" >/dev/null
! grep -q -- '--method POST' "$tmp/recovered-gh.log"

recent_dir="$tmp/recent-workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123"
mkdir -p "$recent_dir"
jq -n \
  --arg attemptedAt "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{schema:1,phase:"intent",repository:"vite-hub/vitehub",number:532,head:"abc123",author:"onmax",attemptedAt:$attemptedAt}' \
  > "$recent_dir/codex-request.json"

recent_result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/recent-gh.log" \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/recent-workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '.result == "review-reconciling" and .blocker == ""' <<< "$recent_result" >/dev/null
! grep -q -- '--method POST' "$tmp/recent-gh.log"

failed_reconcile_dir="$tmp/failed-reconcile-workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-532-abc123"
mkdir -p "$failed_reconcile_dir"
printf '%s\n' '{"schema":1,"phase":"intent","repository":"vite-hub/vitehub","number":532,"head":"abc123","author":"onmax","attemptedAt":"2020-01-01T00:00:00Z"}' \
  > "$failed_reconcile_dir/codex-request.json"

failed_reconcile_result="$(
  PATH="$tmp/bin:$PATH" \
  GH_LOG="$tmp/failed-reconcile-gh.log" \
  GH_COMMENTS_FAIL=1 \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/failed-reconcile-workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '
  .result == "review-reconciling"
  and .blocker == "review-request-reconcile-failed"
' <<< "$failed_reconcile_result" >/dev/null
! grep -q -- '--method POST' "$tmp/failed-reconcile-gh.log"

echo "review request fixture passed"
