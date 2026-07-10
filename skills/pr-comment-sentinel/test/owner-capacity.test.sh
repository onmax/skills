#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts" "$tmp/workspace/pr-comment-sentinel-state/existing/pr-1-head/review"
cp "$skill_dir/scripts/run-heartbeat.sh" "$tmp/scripts/run-heartbeat.sh"
printf '%s\n' "$$" > "$tmp/workspace/pr-comment-sentinel-state/existing/pr-1-head/review/pid"

cat > "$tmp/scripts/heartbeat-state.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"quiverdk/portal","number":773,"head":"abc123","action":"repair","blockers":["checks-failed"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled"}}'
MOCK

cat > "$tmp/scripts/start-repair.sh" <<'MOCK'
#!/usr/bin/env bash
touch "$START_REPAIR_CALLED"
exit 1
MOCK
chmod +x "$tmp/scripts"/*.sh

result="$(
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/workspace" \
  PR_COMMENT_SENTINEL_MAX_OWNERS=1 \
  START_REPAIR_CALLED="$tmp/start-repair-called" \
    "$tmp/scripts/run-heartbeat.sh" gh:quiverdk/portal
)"
jq -e '.result == "deferred" and .blocker == "owner-capacity" and .owner == null' <<< "$result" >/dev/null
[ ! -e "$tmp/start-repair-called" ]

echo "owner capacity fixture passed"
