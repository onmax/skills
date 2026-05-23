---
name: diff
description: Opens the current branch/worktree pull request diff in Zed with the Git panel change list available. Use when the user asks to open, view, inspect, or review the current PR diff in Zed.
---

# Diff

Run this from a branch with an open GitHub pull request:

```sh
/Users/maxi/.agents/skills/diff/scripts/diff.sh
```

It asks GitHub CLI for the current PR base branch, creates a temporary local clone checked out at the merge base, applies the current branch/worktree diff, then opens that temporary repo in Zed.

```sh
zed <temporary-review-worktree>
```

This makes Zed's Git panel show the PR files as normal unstaged changes. If the panel is hidden, use `cmd-shift-g`.

## Feedback workflow

The Zed window is a review clone, not the real PR branch. The user can add local inline feedback such as `// REVIEW: ...` or edit files there without changing the source worktree.

When an agent needs to read the user's feedback:

1. Find the latest review clone from `~/.agents/state/diff/<repo>-pr-<number>.env`.
2. Read `REVIEW_WORKTREE` from that file.
3. Inspect the diff and comments in that review worktree, for example:

```sh
source ~/.agents/state/diff/<repo>-pr-<number>.env
git -C "$REVIEW_WORKTREE" diff
rg -n "REVIEW:|TODO\\(review\\)|AI:" "$REVIEW_WORKTREE"
```

Do not assume feedback written in the review clone exists in the source worktree. Apply requested changes back to `SOURCE_WORKTREE` only after interpreting the review feedback.

```sh
alias diffzed='/Users/maxi/.agents/skills/diff/scripts/diff.sh'
```
