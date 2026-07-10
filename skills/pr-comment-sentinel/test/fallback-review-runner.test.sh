#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/worktree"

cat > "$tmp/bin/codex" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" > "$CODEX_ARGS_LOG"
while [ "$#" -gt 0 ]; do
  if [ "$1" = "--output-last-message" ]; then
    output="$2"
    break
  fi
  shift
done
printf '%s\n' '{"verdict":"no-major-issues","reason":"reviewed exact diff"}' > "$output"
MOCK
chmod +x "$tmp/bin/codex"

printf '%s\n' 'review prompt' > "$tmp/worktree/prompt"
printf '%s\n' '{}' > "$tmp/worktree/schema"

PATH="$tmp/bin:$PATH" \
CODEX_ARGS_LOG="$tmp/args" \
PR_COMMENT_SENTINEL_MODEL=gpt-5.6-sol \
PR_COMMENT_SENTINEL_REASONING_EFFORT=high \
  "$skill_dir/scripts/fallback-review-runner.sh" \
  "$tmp/worktree" abc123 "$tmp/worktree/prompt" "$tmp/worktree/schema" "$tmp/worktree/output"

jq -e '
  .schema == 1
  and .verdict == "no-major-issues"
  and .head == "abc123"
  and .reason == "reviewed exact diff"
  and .model == "gpt-5.6-sol"
  and .reasoningEffort == "high"
' "$tmp/worktree/.pr-comment-sentinel-review.json" >/dev/null
grep -F -- '--model gpt-5.6-sol' "$tmp/args" >/dev/null
grep -F -- 'model_reasoning_effort="high"' "$tmp/args" >/dev/null

echo "fallback review runner fixture passed"
