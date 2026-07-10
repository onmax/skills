#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<'USAGE'
Usage: heartbeat-state.sh [gh:owner/repo ...]

Prints one readiness JSON object per open PR authored by the current GitHub user.
Defaults to gh:vite-hub/vitehub and gh:quiverdk/portal.

Environment:
  PR_COMMENT_SENTINEL_WORKSPACE     Worktree root. Default: /home/workspace
  PR_COMMENT_SENTINEL_MERGE_REPOS   Space/comma-separated owner/repo values allowed to merge
  PR_COMMENT_SENTINEL_COMMENT_REPOS Space/comma-separated owner/repo values allowed one @codex review nudge
USAGE
  exit 0
fi

repos=("$@")
if [ "${#repos[@]}" -eq 0 ]; then
  repos=("gh:vite-hub/vitehub" "gh:quiverdk/portal")
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="${PR_COMMENT_SENTINEL_WORKSPACE:-/home/workspace}"
merge_repos="${PR_COMMENT_SENTINEL_MERGE_REPOS:-}"
comment_repos="${PR_COMMENT_SENTINEL_COMMENT_REPOS:-}"

contains_repo() {
  local haystack="${1//,/ }"
  local needle="$2"
  local item
  for item in $haystack; do
    [ "${item#gh:}" = "$needle" ] && return 0
  done
  return 1
}

for repo_arg in "${repos[@]}"; do
  repo="${repo_arg#gh:}"
  merge_policy="disabled"
  comment_policy="disabled"
  contains_repo "$merge_repos" "$repo" && merge_policy="allowed"
  contains_repo "$comment_repos" "$repo" && comment_policy="allowed"
  repo_dir="${repo//\//-}"

  while IFS=$'\t' read -r pr head; do
    [ -n "$pr" ] || continue
    worktree="$workspace/pr-comment-sentinel/$repo_dir/pr-$pr-$head"
    fallback=""
    if [ -f "$worktree/.pr-comment-sentinel-review.json" ]; then
      fallback="$worktree/.pr-comment-sentinel-review.json"
    elif [ -f "$worktree/.pr-comment-sentinel-review.status" ]; then
      fallback="$worktree/.pr-comment-sentinel-review.status"
    fi

    args=(
      --expected-head "$head"
      --merge "$merge_policy"
      --comments "$comment_policy"
    )
    [ -z "$fallback" ] || args+=(--fallback "$fallback")
    "$script_dir/pr-readiness.sh" "${args[@]}" "$repo" "$pr"
  done < <(
    gh pr list \
      --repo "$repo" \
      --author @me \
      --state open \
      --limit 100 \
      --json number,headRefOid \
      --jq '.[] | [.number, .headRefOid] | @tsv'
  )
done
