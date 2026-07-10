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
printf '%s\n' $'773\tabc123' $'774\tdef456'
MOCK

cat > "$tmp/scripts/pr-readiness.sh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
repo="${@: -2:1}"
pr="${@: -1}"
if [ "$pr" = 773 ]; then
  echo "temporary GitHub failure" >&2
  exit 1
fi
jq -cn --arg repository "$repo" --argjson number "$pr" \
  '{repository:$repository, number:$number, head:"def456", action:"wait-checks", blockers:["checks-pending"], policy:{merge:"disabled",repair:"allowed",comments:"disabled"}}'
MOCK
chmod +x "$tmp/bin/gh" "$tmp/scripts"/*.sh

result="$(
  PATH="$tmp/bin:$PATH" \
  PR_COMMENT_SENTINEL_REPAIR_REPOS=quiverdk/portal \
    "$tmp/scripts/heartbeat-state.sh" gh:quiverdk/portal
)"

[ "$(wc -l <<< "$result" | tr -d ' ')" = 2 ]
jq -se '
  .[0].number == 773
  and .[0].action == "wait-observation"
  and .[0].observation.error == "temporary GitHub failure"
  and .[1].number == 774
  and .[1].action == "wait-checks"
' <<< "$result" >/dev/null

echo "observation fault isolation fixture passed"
