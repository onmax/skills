# GitHub GraphQL Review Threads

Use GraphQL for inline review threads because REST comment IDs are not enough to resolve conversations. GitHub exposes review thread nodes through `PullRequestReviewThread`, and resolves them with `resolveReviewThread`.

## Fetch unresolved threads

```sh
gh api graphql \
  -f owner='OWNER' \
  -f repo='REPO' \
  -F number=123 \
  -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          comments(first: 20) {
            nodes {
              id
              author { login }
              body
              url
            }
          }
        }
      }
    }
  }
}' | jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
```

## Resolve a thread

Run this after `pr-refiner` has implemented, checked, pushed, and verified that the thread is addressed, or after explicit user approval:

```sh
gh api graphql \
  -f threadId='PRRT_...' \
  -f query='
mutation($threadId: ID!) {
  resolveReviewThread(input: { threadId: $threadId }) {
    thread {
      id
      isResolved
    }
  }
}'
```

If the command fails with permission or node errors, report the exact error and do not retry destructively.
