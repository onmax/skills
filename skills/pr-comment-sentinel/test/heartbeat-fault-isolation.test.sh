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
printf '%s\n' \
  '{"repository":"quiverdk/portal","number":773,"head":"abc123","action":"repair","blockers":["checks-failed"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled"}}' \
  '{"repository":"quiverdk/portal","number":774,"head":"def456","action":"wait-checks","blockers":["checks-pending"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled"}}'
MOCK

cat > "$tmp/scripts/start-repair.sh" <<'MOCK'
#!/usr/bin/env bash
exit 2
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"quiverdk/portal","number":773,"head":"abc123","action":"repair","blockers":["checks-failed"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled","notBefore":""}}'
MOCK
chmod +x "$tmp/scripts"/*.sh

result="$($tmp/scripts/run-heartbeat.sh gh:quiverdk/portal)"
[ "$(wc -l <<< "$result" | tr -d ' ')" = 2 ]
jq -se '
  .[0].result == "worker-launch-failed"
  and .[0].blocker == "repair-owner-launch-failed"
  and .[1].number == 774
  and .[1].result == "waiting"
' <<< "$result" >/dev/null

echo "heartbeat fault isolation fixture passed"
