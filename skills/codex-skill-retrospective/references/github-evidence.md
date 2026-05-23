# GitHub Evidence

GitHub evidence supports Codex-session analysis. Start from Codex evidence, then inspect linked or strongly implied GitHub activity.

## Resolve Repository and User

Inside a repo:

```sh
gh repo view --json nameWithOwner,defaultBranchRef,url
gh api user --jq '.login'
```

## Find PRs from a Branch

```sh
gh pr list --state all --head BRANCH --json number,title,state,url,headRefName,baseRefName,updatedAt,author
```

Find PRs mentioning a branch, commit, or topic:

```sh
gh search prs "repo:OWNER/REPO SEARCH" --json number,title,state,url,updatedAt,author
```

## Inspect a Linked PR

```sh
gh pr view PR_NUMBER \
  --json number,title,state,url,author,headRefName,baseRefName,mergeStateStatus,isDraft,commits,comments,reviews,reviewDecision,statusCheckRollup,updatedAt
```

## Review Comments and Threads

Top-level comments and reviews:

```sh
gh pr view PR_NUMBER --comments
gh pr view PR_NUMBER --json reviews,comments
```

Inline review threads require GraphQL:

```sh
gh api graphql -f owner=OWNER -f name=REPO -F number=PR_NUMBER -f query='
query($owner:String!, $name:String!, $number:Int!) {
  repository(owner:$owner, name:$name) {
    pullRequest(number:$number) {
      reviewThreads(first:100) {
        nodes {
          isResolved
          path
          line
          comments(first:20) {
            nodes {
              author { login }
              createdAt
              body
            }
          }
        }
      }
    }
  }
}'
```

## Checks and CI Failures

```sh
gh pr checks PR_NUMBER --watch=false
gh run list --branch BRANCH --limit 20
gh run view RUN_ID --log-failed
```

Classify failed checks as evidence only when they connect to a Codex action, missed verification, repeated repo pattern, or user correction.

## Recent User Activity

Use this only after Codex sessions point toward a repo, branch, or PR.

```sh
gh search prs "repo:OWNER/REPO author:@me updated:>YYYY-MM-DD" --json number,title,state,url,updatedAt,headRefName
gh search issues "repo:OWNER/REPO involves:@me updated:>YYYY-MM-DD" --json number,title,state,url,updatedAt
```

## Related Stacks

Inspect nearby PRs when evidence suggests stacked work or a shared failure pattern:

```sh
gh pr list --state all --search "head:BRANCH_PREFIX" --json number,title,state,url,headRefName,baseRefName,updatedAt
gh search prs "repo:OWNER/REPO BASE_BRANCH_OR_TOPIC updated:>YYYY-MM-DD" --json number,title,state,url,headRefName,baseRefName,updatedAt
```

Label this as scope expansion in the final report.

## Attribution

Always label source/actor:

- user request in Codex
- assistant action in Codex
- GitHub author
- reviewer
- CI/check
- merge bot or automation

Do not post comments, resolve threads, edit PRs, or mutate GitHub state from this skill.

