#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/scripts"
cp "$skill_dir/scripts/heartbeat-state.sh" "$tmp/scripts/heartbeat-state.sh"

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
if [ "$1 $2" = "pr list" ]; then
  printf '531\tabc123\n'
  exit 0
fi
exit 1
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$ARGS_LOG"
printf '%s\n' '{}'
MOCK

chmod +x "$tmp/bin/gh" "$tmp/scripts"/*.sh

PATH="$tmp/bin:$PATH" \
ARGS_LOG="$tmp/args.log" \
PR_COMMENT_SENTINEL_NOT_BEFORE=2026-07-10T05:50:28Z \
PR_COMMENT_SENTINEL_FULL_QUEUE_REPOS=vite-hub/vitehub \
  "$tmp/scripts/heartbeat-state.sh" gh:vite-hub/vitehub gh:quiverdk/portal >/dev/null

vitehub_args="$(sed -n '1p' "$tmp/args.log")"
portal_args="$(sed -n '2p' "$tmp/args.log")"

[[ "$vitehub_args" != *"--not-before"* ]]
[[ "$portal_args" == *"--not-before 2026-07-10T05:50:28Z"* ]]

echo "full queue policy fixture passed"
