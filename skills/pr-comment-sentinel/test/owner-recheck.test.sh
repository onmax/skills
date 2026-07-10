#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts"
cp "$skill_dir/scripts/run-heartbeat.sh" "$tmp/scripts/run-heartbeat.sh"
cp "$skill_dir/scripts/process-owner.sh" "$tmp/scripts/process-owner.sh"

cat > "$tmp/scripts/heartbeat-state.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"vite-hub/vitehub","number":531,"head":"abc123","action":"fallback-review","blockers":["fallback-review-required"],"policy":{"merge":"allowed","repair":"allowed","comments":"allowed","notBefore":""}}'
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"vite-hub/vitehub","number":531,"head":"abc123","action":"repair","blockers":["review-needs-fix"],"policy":{"merge":"allowed","repair":"allowed","comments":"allowed","notBefore":""}}'
MOCK

cat > "$tmp/scripts/start-fallback-review.sh" <<'MOCK'
#!/usr/bin/env bash
touch "$STARTED"
exit 1
MOCK

chmod +x "$tmp/scripts"/*.sh

result="$(
  STARTED="$tmp/started" \
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/workspace" \
    "$tmp/scripts/run-heartbeat.sh" gh:vite-hub/vitehub
)"

jq -e '
  .action == "fallback-review"
  and .result == "cancelled-after-recheck"
  and .blocker == "review-needs-fix"
' <<< "$result" >/dev/null
[ ! -e "$tmp/started" ]

echo "owner recheck fixture passed"
