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
printf '%s\n' '{"status":"pushed","reason":"fixed the failing check","checks":["pnpm test"]}' > "$output"
MOCK

cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' new-head
MOCK
chmod +x "$tmp/bin/codex" "$tmp/bin/gh"

printf '%s\n' 'repair prompt' > "$tmp/control/prompt"
printf '%s\n' '{}' > "$tmp/control/schema"

PATH="$tmp/bin:$PATH" \
CODEX_ARGS_LOG="$tmp/args" \
PR_COMMENT_SENTINEL_MODEL=gpt-5.6-sol \
PR_COMMENT_SENTINEL_REASONING_EFFORT=high \
  "$skill_dir/scripts/repair-runner.sh" \
  "$tmp/worktree" quiverdk/portal 773 old-head "$tmp/control" \
  "$tmp/control/prompt" "$tmp/control/schema" "$tmp/control/output"

jq -e '
  .schema == 1
  and .status == "pushed"
  and .authorizedHead == "old-head"
  and .head == "new-head"
  and .reason == "fixed the failing check"
  and .checks == ["pnpm test"]
  and .model == "gpt-5.6-sol"
  and .reasoningEffort == "high"
' "$tmp/control/result.json" >/dev/null
grep -F -- '--dangerously-bypass-approvals-and-sandbox' "$tmp/args" >/dev/null
grep -F -- '--model gpt-5.6-sol' "$tmp/args" >/dev/null
grep -F -- 'model_reasoning_effort="high"' "$tmp/args" >/dev/null
[ -z "$(find "$tmp/worktree" -mindepth 1 -maxdepth 1 -print -quit)" ]

echo "repair runner fixture passed"
