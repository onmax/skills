#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'USAGE'
Usage:
  pr-readiness.sh [options] owner/repo pr-number
  pr-readiness.sh --input snapshot.json

Options:
  --expected-head SHA       Fail closed if the observed head differs.
  --fallback FILE           Exact-head fallback review JSON or legacy status file.
  --merge allowed|disabled  Whether a ready PR may be merged. Default: disabled.
  --comments allowed|disabled
                            Whether the exact @codex review nudge is authorized. Default: disabled.
  --input FILE              Classify a normalized fixture without calling GitHub.
USAGE
}

expected_head=""
fallback_file=""
merge_policy="disabled"
comment_policy="disabled"
input_file=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --expected-head)
      expected_head="${2:?missing expected head}"
      shift 2
      ;;
    --fallback)
      fallback_file="${2:?missing fallback file}"
      shift 2
      ;;
    --merge)
      merge_policy="${2:?missing merge policy}"
      shift 2
      ;;
    --comments)
      comment_policy="${2:?missing comment policy}"
      shift 2
      ;;
    --input)
      input_file="${2:?missing input file}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 64
      ;;
    *)
      break
      ;;
  esac
done

if [ -n "$input_file" ]; then
  [ "$#" -eq 0 ] || { usage >&2; exit 64; }
  jq -c -f "$script_dir/readiness.jq" "$input_file"
  exit
fi

[ "$#" -eq 2 ] || { usage >&2; exit 64; }
[ "$merge_policy" = "allowed" ] || [ "$merge_policy" = "disabled" ] || { echo "invalid merge policy" >&2; exit 64; }
[ "$comment_policy" = "allowed" ] || [ "$comment_policy" = "disabled" ] || { echo "invalid comment policy" >&2; exit 64; }

repo="${1#gh:}"
pr="$2"
owner="${repo%%/*}"
name="${repo#*/}"
[ "$owner" != "$repo" ] || { echo "repository must be owner/name" >&2; exit 64; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
started_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

viewer="$(gh api user --jq .login)"
gh pr view "$pr" --repo "$repo" --json number,title,author,headRefOid,isDraft,mergeStateStatus > "$tmp/pr.json"
head_sha="$(jq -r '.headRefOid' "$tmp/pr.json")"
[ -n "$expected_head" ] || expected_head="$head_sha"
head_date="$(gh api "repos/$repo/commits/$head_sha" --jq '.commit.committer.date')"

gh api --paginate "repos/$repo/issues/$pr/comments" \
  | jq -s 'add | map({id, body: (.body // ""), createdAt: .created_at, author: .user.login})' \
  > "$tmp/comments.json"

gh api --paginate "repos/$repo/pulls/$pr/reviews" \
  | jq -s 'add | map({id, body: (.body // ""), submittedAt: .submitted_at, head: .commit_id, author: .user.login, state})' \
  > "$tmp/reviews.json"

gh api --paginate -H "Accept: application/vnd.github+json" "repos/$repo/issues/$pr/reactions" \
  | jq -s 'add | map({id, content, createdAt: .created_at, author: .user.login})' \
  > "$tmp/reactions.json"

gh api graphql --paginate --slurp \
  -F owner="$owner" \
  -F name="$name" \
  -F number="$pr" \
  -f query='query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
    repository(owner: $owner, name: $name) {
      pullRequest(number: $number) {
        reviewThreads(first: 100, after: $endCursor) {
          nodes { isResolved isOutdated }
          pageInfo { hasNextPage endCursor }
        }
      }
    }
  }' \
  | jq '[.[]?.data.repository.pullRequest.reviewThreads.nodes[]?]' \
  > "$tmp/threads.json"

set +e
gh pr checks "$pr" --repo "$repo" --json bucket,name,state,workflow > "$tmp/checks.json" 2> "$tmp/checks.err"
checks_rc=$?
set -e
if ! jq -e 'type == "array"' "$tmp/checks.json" >/dev/null 2>&1; then
  printf '[]\n' > "$tmp/checks.json"
elif [ "$checks_rc" -ne 0 ] && [ ! -s "$tmp/checks.json" ]; then
  printf '[]\n' > "$tmp/checks.json"
fi

fallback_json='null'
if [ -n "$fallback_file" ] && [ -f "$fallback_file" ]; then
  fallback_dir="$(cd "$(dirname "$fallback_file")" && pwd)"
  observable=false
  if [ -f "$fallback_dir/.pr-comment-sentinel-review.prompt.md" ] \
    && [ -f "$fallback_dir/.pr-comment-sentinel-review.log" ] \
    && [ -f "$fallback_dir/.pr-comment-sentinel-review.pid" ]; then
    observable=true
  fi

  if jq -e '.schema == 1 and (.verdict | type == "string") and (.head | type == "string") and (.reviewedAt | type == "string")' "$fallback_file" >/dev/null 2>&1; then
    fallback_json="$(jq -c --argjson observable "$observable" '{verdict, head, createdAt: .reviewedAt, reason: (.reason // ""), observable: $observable}' "$fallback_file")"
  else
    fallback_line="$(sed -n '1p' "$fallback_file")"
    verdict="$(sed -n 's/.*verdict=\([^ ]*\).*/\1/p' <<< "$fallback_line")"
    fallback_head="$(sed -n 's/.*head=\([^ ]*\).*/\1/p' <<< "$fallback_line")"
    if [ -n "$verdict" ] && [ -n "$fallback_head" ]; then
      if epoch="$(stat -c %Y "$fallback_file" 2>/dev/null)"; then
        created_at="$(date -u -d "@$epoch" +%Y-%m-%dT%H:%M:%SZ)"
      else
        epoch="$(stat -f %m "$fallback_file")"
        created_at="$(date -u -r "$epoch" +%Y-%m-%dT%H:%M:%SZ)"
      fi
      fallback_json="$(jq -cn \
        --arg verdict "$verdict" \
        --arg head "$fallback_head" \
        --arg createdAt "$created_at" \
        --argjson observable "$observable" \
        '{verdict: $verdict, head: $head, createdAt: $createdAt, reason: "legacy status", observable: $observable}')"
    fi
  fi
fi

head_after="$(gh pr view "$pr" --repo "$repo" --json headRefOid --jq .headRefOid)"
finished_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

jq -n \
  --arg repository "$repo" \
  --argjson number "$pr" \
  --arg expectedHead "$expected_head" \
  --arg viewer "$viewer" \
  --arg codexBot "${PR_COMMENT_SENTINEL_CODEX_BOT:-chatgpt-codex-connector[bot]}" \
  --arg headDate "$head_date" \
  --arg headAfter "$head_after" \
  --arg startedAt "$started_at" \
  --arg finishedAt "$finished_at" \
  --arg merge "$merge_policy" \
  --arg comments "$comment_policy" \
  --argjson fallback "$fallback_json" \
  --slurpfile pr "$tmp/pr.json" \
  --slurpfile checks "$tmp/checks.json" \
  --slurpfile threads "$tmp/threads.json" \
  --slurpfile issueComments "$tmp/comments.json" \
  --slurpfile reviews "$tmp/reviews.json" \
  --slurpfile reactions "$tmp/reactions.json" \
  '{
    schema: 1,
    repository: $repository,
    number: $number,
    expectedHead: $expectedHead,
    viewer: $viewer,
    codexBot: $codexBot,
    author: $pr[0].author.login,
    title: $pr[0].title,
    draft: $pr[0].isDraft,
    mergeState: ($pr[0].mergeStateStatus // "UNKNOWN"),
    head: { sha: $pr[0].headRefOid, committedAt: $headDate },
    policy: { merge: $merge, comments: $comments, checks: "all-visible" },
    checks: $checks[0],
    threads: $threads[0],
    comments: $issueComments[0],
    reviews: $reviews[0],
    reactions: $reactions[0],
    fallback: $fallback,
    collection: { startedAt: $startedAt, finishedAt: $finishedAt, headAfter: $headAfter }
  }' \
  | jq -c -f "$script_dir/readiness.jq"
