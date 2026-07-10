#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="${PR_COMMENT_SENTINEL_WORKSPACE:-/home/workspace}"
max_owners="${PR_COMMENT_SENTINEL_MAX_OWNERS:-2}"
repos=("$@")
[ "${#repos[@]}" -gt 0 ] || repos=("gh:vite-hub/vitehub" "gh:quiverdk/portal")
[[ "$max_owners" =~ ^[1-9][0-9]*$ ]] || { echo "invalid owner limit" >&2; exit 64; }

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

"$script_dir/heartbeat-state.sh" "${repos[@]}" > "$tmp"

owner_pid() {
  local repo="$1"
  local pr="$2"
  local head="$3"
  local state="$workspace/pr-comment-sentinel-state/${repo//\//-}/pr-$pr-$head"
  local file pid
  for file in "$state"/review/pid "$state"/repair-*/pid; do
    [ -s "$file" ] || continue
    pid="$(cat "$file")"
    if kill -0 "$pid" 2>/dev/null; then
      printf '%s\n' "$pid"
      return
    fi
  done
}

live_owner_count() {
  local count=0 file pid
  while IFS= read -r file; do
    [ -s "$file" ] || continue
    pid="$(cat "$file")"
    if kill -0 "$pid" 2>/dev/null; then
      count="$((count + 1))"
    fi
  done < <(find "$workspace/pr-comment-sentinel-state" -type f -name pid -print 2>/dev/null || true)
  printf '%s\n' "$count"
}

fallback_path() {
  local repo="$1"
  local pr="$2"
  local head="$3"
  local worktree="$workspace/pr-comment-sentinel/${repo//\//-}/pr-$pr-$head"
  local state="$workspace/pr-comment-sentinel-state/${repo//\//-}/pr-$pr-$head/review/result.json"

  if [ -f "$state" ]; then
    printf '%s\n' "$state"
  elif [ -f "$worktree/.pr-comment-sentinel-review.json" ]; then
    printf '%s\n' "$worktree/.pr-comment-sentinel-review.json"
  elif [ -f "$worktree/.pr-comment-sentinel-review.status" ]; then
    printf '%s\n' "$worktree/.pr-comment-sentinel-review.status"
  fi
}

recheck() {
  local snapshot="$1"
  local repo pr head merge_policy repair_policy comment_policy not_before fallback
  repo="$(jq -r .repository <<< "$snapshot")"
  pr="$(jq -r .number <<< "$snapshot")"
  head="$(jq -r .head <<< "$snapshot")"
  merge_policy="$(jq -r .policy.merge <<< "$snapshot")"
  repair_policy="$(jq -r .policy.repair <<< "$snapshot")"
  comment_policy="$(jq -r .policy.comments <<< "$snapshot")"
  not_before="$(jq -r '.policy.notBefore // ""' <<< "$snapshot")"
  fallback="$(fallback_path "$repo" "$pr" "$head")"

  args=(
    --expected-head "$head"
    --merge "$merge_policy"
    --repair "$repair_policy"
    --comments "$comment_policy"
  )
  [ -z "$not_before" ] || args+=(--not-before "$not_before")
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
    repair)
      existing_pid="$(owner_pid "$repo" "$pr" "$head")"
      if [ -z "$existing_pid" ] && [ "$(live_owner_count)" -ge "$max_owners" ]; then
        result="deferred"
        blocker="owner-capacity"
      elif owner="$($script_dir/start-repair.sh "$repo" "$pr" "$head" <<< "$snapshot")"; then
        result="worker-$(jq -r .status <<< "$owner")"
      else
        rc=$?
        owner="$(jq -cn --argjson exitCode "$rc" '{status:"launch-failed", exitCode:$exitCode}')"
        result="worker-launch-failed"
        blocker="repair-owner-launch-failed"
      fi
      ;;
    fallback-review)
      existing_pid="$(owner_pid "$repo" "$pr" "$head")"
      if [ -z "$existing_pid" ] && [ "$(live_owner_count)" -ge "$max_owners" ]; then
        result="deferred"
        blocker="owner-capacity"
      elif owner="$($script_dir/start-fallback-review.sh "$repo" "$pr" "$head")"; then
        result="worker-$(jq -r .status <<< "$owner")"
      else
        rc=$?
        owner="$(jq -cn --argjson exitCode "$rc" '{status:"launch-failed", exitCode:$exitCode}')"
        result="worker-launch-failed"
        blocker="review-owner-launch-failed"
      fi
      ;;
    merge)
      if ! fresh="$(recheck "$snapshot")"; then
        result="recheck-failed"
        blocker="merge-recheck-failed"
      elif [ "$(jq -r .action <<< "$fresh")" = "merge" ]; then
        title="$(jq -r .title <<< "$fresh")"
        if gh pr merge "$pr" \
          --repo "$repo" \
          --squash \
          --subject "$title" \
          --body "" \
          --match-head-commit "$head"; then
          result="merged"
          blocker=""
        else
          result="merge-failed"
          blocker="merge-command-failed"
        fi
      else
        result="cancelled-after-recheck"
        blocker="$(jq -cr '.blockers | join(",")' <<< "$fresh")"
      fi
      ;;
    mark-ready)
      if ! fresh="$(recheck "$snapshot")"; then
        result="recheck-failed"
        blocker="ready-recheck-failed"
      elif [ "$(jq -r .action <<< "$fresh")" = "mark-ready" ]; then
        if gh pr ready "$pr" --repo "$repo"; then
          result="marked-ready"
          blocker=""
        else
          result="ready-transition-failed"
          blocker="ready-command-failed"
        fi
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
