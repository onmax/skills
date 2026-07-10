#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
while [ "$#" -gt 0 ]; do
  if [ "$1" = "--repo" ]; then
    printf '%s\n' "$2" >> "$GH_REPOS_LOG"
    exit 0
  fi
  shift
done
exit 1
MOCK
chmod +x "$tmp/bin/gh"

PATH="$tmp/bin:$PATH" GH_REPOS_LOG="$tmp/repos" \
  "$skill_dir/scripts/heartbeat-state.sh" >/dev/null

diff -u <(printf '%s\n' vite-hub/vitehub quiverdk/portal) "$tmp/repos"
echo "default repository fixture passed"
