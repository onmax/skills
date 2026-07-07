#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 owner/repo pr-number [expected-head-sha]" >&2
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  usage
  exit 64
fi

repo="$1"
pr="$2"
expected_head="${3:-}"
codex_bot="${PR_COMMENT_SENTINEL_CODEX_BOT:-chatgpt-codex-connector[bot]}"

pr_json="$(gh api "repos/${repo}/pulls/${pr}")"
head_sha="$(jq -r '.head.sha' <<<"$pr_json")"

if [ -n "$expected_head" ] && [ "$expected_head" != "$head_sha" ]; then
  echo "blocked: PR #${pr} head changed from ${expected_head} to ${head_sha}"
  exit 2
fi

head_date="$(gh api "repos/${repo}/commits/${head_sha}" --jq '.commit.committer.date')"

comments_json="$(gh api --paginate "repos/${repo}/issues/${pr}/comments" | jq -s 'add')"
latest_command="$(
  jq -c --arg head_date "$head_date" '
    [
      .[]
      | select((.body // "" | test("(^|[[:space:]])@codex\\b"; "i")) and (.created_at > $head_date))
    ]
    | max_by(.created_at) // null
  ' <<<"$comments_json"
)"

if [ "$latest_command" = "null" ]; then
  exit 0
fi

command_created="$(jq -r '.created_at' <<<"$latest_command")"
command_id="$(jq -r '.id' <<<"$latest_command")"
command_author="$(jq -r '.user.login' <<<"$latest_command")"

reviews_json="$(gh api --paginate "repos/${repo}/pulls/${pr}/reviews" | jq -s 'add')"
has_newer_review="$(
  jq -r --arg bot "$codex_bot" --arg head "$head_sha" --arg command_created "$command_created" '
    any(.[]; .user.login == $bot and .commit_id == $head and .submitted_at > $command_created)
  ' <<<"$reviews_json"
)"

reactions_json="$(gh api --paginate -H "Accept: application/vnd.github+json" "repos/${repo}/issues/${pr}/reactions" | jq -s 'add')"
has_newer_thumbs_up="$(
  jq -r --arg bot "$codex_bot" --arg command_created "$command_created" '
    any(.[]; .user.login == $bot and .content == "+1" and .created_at > $command_created)
  ' <<<"$reactions_json"
)"

if [ "$has_newer_review" = "true" ] || [ "$has_newer_thumbs_up" = "true" ]; then
  exit 0
fi

echo "blocked: PR #${pr} has @codex command ${command_id} by ${command_author} at ${command_created} after head ${head_sha}; wait for a newer Codex bot review or +1 reaction"
exit 2
