#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
workspace="$tmp/workspace"
mkdir -p "$tmp/bin"

repo="$workspace/pr-comment-sentinel/quiverdk-portal"
mkdir -p "$repo/source"
git -C "$repo/source" init -q
git -C "$repo/source" config user.name test
git -C "$repo/source" config user.email test@example.com
printf '%s\n' base > "$repo/source/file.txt"
git -C "$repo/source" add file.txt
git -C "$repo/source" commit -qm base
base="$(git -C "$repo/source" rev-parse HEAD)"
printf '%s\n' target >> "$repo/source/file.txt"
git -C "$repo/source" commit -qam target
head="$(git -C "$repo/source" rev-parse HEAD)"
git -C "$repo/source" checkout -q --detach "$base"
worktree="$repo/pr-773-$head"
mv "$repo/source" "$worktree"

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
jq -cn \
  --arg base "$MOCK_BASE" \
  --arg head "$MOCK_HEAD" \
  '{baseRefOid:$base,headRefName:"feature",headRefOid:$head,title:"fix: test",url:"https://example.test/pr/773"}'
MOCK

cat > "$tmp/bin/setsid" <<'MOCK'
#!/usr/bin/env bash
touch "$SETSID_MARKER"
sleep 30
MOCK
chmod +x "$tmp/bin/gh" "$tmp/bin/setsid"

snapshot="$(jq -cn \
  --arg head "$head" \
  '{repository:"quiverdk/portal",number:773,head:$head,action:"repair",titleValid:true,mergeState:"UNSTABLE",checks:{failedDetails:[]},reviewThreads:{ids:[]},reviewEvidence:{source:"none"},fallback:{createdAt:null,reason:null}}'
)"
state_root="$workspace/pr-comment-sentinel-state/quiverdk-portal/pr-773-$head"
mkdir -p "$state_root/review"
printf '%s\n' 'review only' > "$state_root/review/prompt.md"
printf '%s\n' "$$" > "$state_root/review/pid"

set +e
PATH="$tmp/bin:$PATH" \
MOCK_BASE="$base" \
MOCK_HEAD="$head" \
SETSID_MARKER="$tmp/setsid-called" \
PR_COMMENT_SENTINEL_WORKSPACE="$workspace" \
  "$skill_dir/scripts/start-repair.sh" quiverdk/portal 773 "$head" <<< "$snapshot" > "$tmp/reject.out" 2> "$tmp/reject.err"
rc=$?
set -e

[ "$rc" -ne 0 ]
[ ! -e "$tmp/setsid-called" ]
grep -F 'repair checkout is at' "$tmp/reject.err" >/dev/null

git -C "$worktree" checkout -q --detach "$head"
printf '%s\n' orphan >> "$worktree/file.txt"
git -C "$worktree" commit -qam orphan
mkdir -p "$state_root/repair-prior"
printf '%s\n' 'repair owner' > "$state_root/repair-prior/prompt.md"

result="$(
  PATH="$tmp/bin:$PATH" \
  MOCK_BASE="$base" \
  MOCK_HEAD="$head" \
  SETSID_MARKER="$tmp/setsid-called" \
  PR_COMMENT_SENTINEL_WORKSPACE="$workspace" \
    "$skill_dir/scripts/start-repair.sh" quiverdk/portal 773 "$head" <<< "$snapshot"
)"
jq -e '.status == "started" and (.control | contains("pr-comment-sentinel-state"))' <<< "$result" >/dev/null
kill "$(jq -r .pid <<< "$result")" 2>/dev/null || true
echo "repair worktree guard fixture passed"
