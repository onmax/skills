#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

cat > "$tmp/request.json" <<'JSON'
{"schema":1,"phase":"posted","repository":"vite-hub/vitehub","number":525,"head":"abc123","author":"onmax","commentId":42,"requestedAt":"2026-07-09T16:10:00Z"}
JSON

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$GH_LOG"

if [ "$1 $2" = "api user" ]; then
  printf '%s\n' onmax
elif [ "$1 $2" = "pr view" ]; then
  if [[ "$*" == *"--jq .headRefOid"* ]]; then
    printf '%s\n' abc123
  else
    printf '%s\n' '{"number":525,"title":"fix(agent): preserve data events","author":{"login":"onmax"},"createdAt":"2026-07-09T15:00:00Z","headRefOid":"abc123","isDraft":false,"mergeStateStatus":"CLEAN"}'
  fi
elif [ "$1 $2" = "api graphql" ]; then
  printf '%s\n' '[{"data":{"repository":{"pullRequest":{"reviewThreads":{"nodes":[]}}}}}]'
elif [ "$1 $2" = "pr checks" ]; then
  printf '%s\n' '[{"bucket":"pass","completedAt":"2026-07-09T16:09:00Z","link":"https://example.test/ci","name":"ci","state":"SUCCESS","workflow":"CI"}]'
elif [[ "$*" == *"repos/vite-hub/vitehub/commits/abc123"* ]]; then
  printf '%s\n' '2026-07-09T16:00:00Z'
elif [[ "$*" == *"repos/vite-hub/vitehub/issues/525/comments"* ]]; then
  printf '%s\n' '[]'
elif [[ "$*" == *"repos/vite-hub/vitehub/pulls/525/reviews"* ]]; then
  printf '%s\n' '[]'
elif [[ "$*" == *"repos/vite-hub/vitehub/issues/comments/42/reactions"* ]]; then
  printf '%s\n' '[{"id":9,"content":"+1","created_at":"2026-07-09T16:10:09Z","user":{"login":"chatgpt-codex-connector[bot]"}}]'
else
  echo "unexpected gh call: $*" >&2
  exit 2
fi
MOCK
chmod +x "$tmp/bin/gh"

result="$(
  PATH="$tmp/bin:$PATH" GH_LOG="$tmp/gh.log" PR_COMMENT_SENTINEL_NOT_BEFORE=2030-01-01T00:00:00Z \
    "$skill_dir/scripts/pr-readiness.sh" \
      --expected-head abc123 \
      --codex-request "$tmp/request.json" \
      --merge allowed \
      --repair allowed \
      --comments allowed \
      --not-before '' \
      vite-hub/vitehub 525
)"

jq -e '
  .codexLane.state == "reviewed"
  and .reviewEvidence.source == "codex-thumbs-up"
  and .action == "merge"
' <<< "$result" >/dev/null

grep -q 'repos/vite-hub/vitehub/issues/comments/42/reactions' "$tmp/gh.log"
! grep -q 'repos/vite-hub/vitehub/issues/525/reactions' "$tmp/gh.log"

echo "request reaction source fixture passed"
