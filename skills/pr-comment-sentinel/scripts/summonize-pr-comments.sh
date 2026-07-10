#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<'USAGE'
Usage: summonize-pr-comments.sh [gh:owner/repo ...]

Prints the bounded coordinator prompt. Defaults to gh:vite-hub/vitehub.
USAGE
  exit 0
fi

repos=("$@")
if [ "${#repos[@]}" -eq 0 ]; then
  repos=("gh:vite-hub/vitehub")
fi

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
workspace="${PR_COMMENT_SENTINEL_WORKSPACE:-/home/workspace}"
merge_repos="${PR_COMMENT_SENTINEL_MERGE_REPOS:-vite-hub/vitehub}"
comment_repos="${PR_COMMENT_SENTINEL_COMMENT_REPOS:-}"

printf -v repo_args ' %q' "${repos[@]}"
printf -v workspace_q '%q' "$workspace"
printf -v merge_repos_q '%q' "$merge_repos"
printf -v comment_repos_q '%q' "$comment_repos"

cat <<PROMPT
Use \$pr-comment-sentinel from ${skill_dir}.

Run one bounded heartbeat. The readiness scripts are authoritative; do not reconstruct their GitHub queries or gates in prose.

1. Run:
   PR_COMMENT_SENTINEL_WORKSPACE=${workspace_q} PR_COMMENT_SENTINEL_MERGE_REPOS=${merge_repos_q} PR_COMMENT_SENTINEL_COMMENT_REPOS=${comment_repos_q} ${skill_dir}/scripts/heartbeat-state.sh${repo_args}
2. Execute only each snapshot's named action. For worker actions, read ${skill_dir}/WORKERS.md, create or reuse one observable owner per PR/head, and leave its evidence for the next heartbeat.
3. Re-run ${skill_dir}/scripts/pr-readiness.sh with the same policies and expected head immediately before any review nudge, ready transition, or merge. A changed action cancels the mutation.
4. Post no comments unless the fresh action is request-review; that action permits only the exact body "@codex review".
5. Report one compact ledger row per authored PR: repository, number, head, action, owner pid/thread and log when present, result, and blocker. Exit after this pass without polling.
PROMPT
