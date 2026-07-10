#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/worktree" "$tmp/control"

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

printf '%s\n' 'review prompt' > "$tmp/control/prompt"
printf '%s\n' '{}' > "$tmp/control/schema"

PATH="$tmp/bin:$PATH" \
CODEX_ARGS_LOG="$tmp/args" \
PR_COMMENT_SENTINEL_MODEL=gpt-5.6-sol \
PR_COMMENT_SENTINEL_REASONING_EFFORT=high \
  "$skill_dir/scripts/fallback-review-runner.sh" \
  "$tmp/worktree" abc123 "$tmp/control" "$tmp/control/prompt" "$tmp/control/schema" "$tmp/control/output"

jq -e '
  .schema == 1
  and .verdict == "no-major-issues"
  and .head == "abc123"
  and .reason == "reviewed exact diff"
  and .model == "gpt-5.6-sol"
  and .reasoningEffort == "high"
' "$tmp/control/result.json" >/dev/null
grep -F -- '--model gpt-5.6-sol' "$tmp/args" >/dev/null
grep -F -- 'model_reasoning_effort="high"' "$tmp/args" >/dev/null
[ -z "$(find "$tmp/worktree" -mindepth 1 -maxdepth 1 -print -quit)" ]

failed_control="$tmp/workspace/pr-comment-sentinel-state/vite-hub-vitehub/pr-525-abc123/review"
mkdir -p "$failed_control"
printf '%s\n' 'model unavailable' > "$failed_control/error"
cooldown="$(
  PR_COMMENT_SENTINEL_WORKSPACE="$tmp/workspace" \
  PR_COMMENT_SENTINEL_RETRY_SECONDS=900 \
    "$skill_dir/scripts/start-fallback-review.sh" vite-hub/vitehub 525 abc123
)"
jq -e '
  .status == "failed"
  and .retryInSeconds > 0
  and (.error | endswith("/review/error"))
' <<< "$cooldown" >/dev/null

echo "fallback review runner fixture passed"
