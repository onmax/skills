#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts"
cp "$skill_dir/scripts/run-heartbeat.sh" "$tmp/scripts/run-heartbeat.sh"

cat > "$tmp/scripts/heartbeat-state.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"quiverdk/portal","number":773,"head":"abc123","action":"repair","blockers":["checks-failed"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled"}}'
MOCK

cat > "$tmp/scripts/start-repair.sh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
snapshot="$(cat)"
jq -e '.repository == "quiverdk/portal" and .number == 773 and .action == "repair"' <<< "$snapshot" >/dev/null
printf '%s\n' '{"status":"started","pid":123,"worktree":"/tmp/pr-773"}'
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"repository":"quiverdk/portal","number":773,"head":"abc123","action":"repair","blockers":["checks-failed"],"policy":{"merge":"disabled","repair":"allowed","comments":"disabled","notBefore":""}}'
MOCK
chmod +x "$tmp/scripts"/*.sh

result="$($tmp/scripts/run-heartbeat.sh gh:quiverdk/portal)"
jq -e '
  .repository == "quiverdk/portal"
  and .number == 773
  and .action == "repair"
  and .result == "worker-started"
  and .owner.pid == 123
' <<< "$result" >/dev/null

echo "repair dispatch fixture passed"
