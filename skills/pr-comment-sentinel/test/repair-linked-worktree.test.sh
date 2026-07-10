#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
workspace="$tmp/workspace"
mkdir -p "$tmp/bin" "$tmp/main"

git -C "$tmp/main" init -q
git -C "$tmp/main" config user.name test
git -C "$tmp/main" config user.email test@example.com
printf '%s\n' source > "$tmp/main/file.txt"
git -C "$tmp/main" add file.txt
git -C "$tmp/main" commit -qm source
head="$(git -C "$tmp/main" rev-parse HEAD)"
worktree="$workspace/pr-comment-sentinel/quiverdk-portal/pr-773-$head"
mkdir -p "$(dirname "$worktree")"
git -C "$tmp/main" worktree add -q --detach "$worktree" "$head"

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
jq -cn --arg head "$MOCK_HEAD" \
  '{baseRefOid:$head,headRefName:"feature",headRefOid:$head,title:"fix: test",url:"https://example.test/pr/773"}'
MOCK

cat > "$tmp/bin/setsid" <<'MOCK'
#!/usr/bin/env bash
sleep 30
MOCK
chmod +x "$tmp/bin/gh" "$tmp/bin/setsid"

snapshot="$(jq -cn --arg head "$head" \
  '{repository:"quiverdk/portal",number:773,head:$head,action:"repair",titleValid:true,mergeState:"UNSTABLE",checks:{failedDetails:[]},reviewThreads:{ids:[]},reviewEvidence:{source:"none"},fallback:{createdAt:null,reason:null}}'
)"

result="$(
  PATH="$tmp/bin:$PATH" \
  MOCK_HEAD="$head" \
  PR_COMMENT_SENTINEL_WORKSPACE="$workspace" \
    "$skill_dir/scripts/start-repair.sh" quiverdk/portal 773 "$head" <<< "$snapshot"
)"
jq -e '.status == "started"' <<< "$result" >/dev/null
common_dir="$(git -C "$worktree" rev-parse --path-format=absolute --git-common-dir)"
grep -qxF '/.pr-comment-sentinel-*' "$common_dir/info/exclude"
kill "$(jq -r .pid <<< "$result")" 2>/dev/null || true

echo "repair linked worktree fixture passed"
