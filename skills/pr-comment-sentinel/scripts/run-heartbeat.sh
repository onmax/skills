#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="${PR_COMMENT_SENTINEL_WORKSPACE:-/home/workspace}"
repos=("$@")
[ "${#repos[@]}" -gt 0 ] || repos=("gh:vite-hub/vitehub" "gh:quiverdk/portal")

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

"$script_dir/heartbeat-state.sh" "${repos[@]}" > "$tmp"

fallback_path() {
  local repo="$1"
  local pr="$2"
  local head="$3"
  local worktree="$workspace/pr-comment-sentinel/${repo//\//-}/pr-$pr-$head"

  if [ -f "$worktree/.pr-comment-sentinel-review.json" ]; then
    printf '%s\n' "$worktree/.pr-comment-sentinel-review.json"
  elif [ -f "$worktree/.pr-comment-sentinel-review.status" ]; then
    printf '%s\n' "$worktree/.pr-comment-sentinel-review.status"
  fi
}

recheck() {
  local snapshot="$1"
  local repo pr head merge_policy comment_policy fallback
  repo="$(jq -r .repository <<< "$snapshot")"
  pr="$(jq -r .number <<< "$snapshot")"
  head="$(jq -r .head <<< "$snapshot")"
  merge_policy="$(jq -r .policy.merge <<< "$snapshot")"
  comment_policy="$(jq -r .policy.comments <<< "$snapshot")"
  fallback="$(fallback_path "$repo" "$pr" "$head")"

  args=(
    --expected-head "$head"
    --merge "$merge_policy"
    --comments "$comment_policy"
  )
  [ -z "$fallback" ] || args+=(--fallback "$fallback")
  "$script_dir/pr-readiness.sh" "${args[@]}" "$repo" "$pr"
}

while IFS= read -r snapshot; do
  [ -n "$snapshot" ] || continue
  repo="$(jq -r .repository <<< "$snapshot")"
  pr="$(jq -r .number <<< "$snapshot")"
  head="$(jq -r .head <<< "$snapshot")"
  action="$(jq -r .action <<< "$snapshot")"
  result="waiting"
  owner='null'
  blocker="$(jq -cr '.blockers | join(",")' <<< "$snapshot")"

  case "$action" in
    fallback-review)
      owner="$($script_dir/start-fallback-review.sh "$repo" "$pr" "$head")"
      result="worker-$(jq -r .status <<< "$owner")"
      ;;
    merge)
      fresh="$(recheck "$snapshot")"
      if [ "$(jq -r .action <<< "$fresh")" = "merge" ]; then
        title="$(jq -r .title <<< "$fresh")"
        gh pr merge "$pr" \
          --repo "$repo" \
          --squash \
          --subject "$title" \
          --body "" \
          --match-head-commit "$head"
        result="merged"
        blocker=""
      else
        result="cancelled-after-recheck"
        blocker="$(jq -cr '.blockers | join(",")' <<< "$fresh")"
      fi
      ;;
    mark-ready)
      fresh="$(recheck "$snapshot")"
      if [ "$(jq -r .action <<< "$fresh")" = "mark-ready" ]; then
        gh pr ready "$pr" --repo "$repo"
        result="marked-ready"
        blocker=""
      else
        result="cancelled-after-recheck"
        blocker="$(jq -cr '.blockers | join(",")' <<< "$fresh")"
      fi
      ;;
  esac

  jq -cn \
    --arg repository "$repo" \
    --argjson number "$pr" \
    --arg head "$head" \
    --arg action "$action" \
    --arg result "$result" \
    --arg blocker "$blocker" \
    --argjson owner "$owner" \
    '{repository:$repository, number:$number, head:$head, action:$action, owner:$owner, result:$result, blocker:$blocker}'
done < "$tmp"
