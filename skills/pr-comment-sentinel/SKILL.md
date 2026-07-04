---
name: pr-comment-sentinel
description: Watches GitHub PR comments and review threads, fixes actionable Codex feedback, and squash-merges clean authored PRs after a fresh Codex thumbs-up. Use when setting up passive PR comment handling, a PR heartbeat, or an automated review-fix loop for repositories such as gh:vite-hub/vitehub.
---

# PR Comment Sentinel

A comment has arrived. It might be a bug, a misunderstanding, or noise. This skill keeps a small **queue** of open PRs, reads Codex feedback for intent, and turns only actionable comments into patches.

The default repo is `gh:vite-hub/vitehub`. Add more repos in the script call, not in the skill text.

## The Queue

The queue is all open PRs in the watched repos where the current GitHub user is the author.

Each heartbeat:
- list open PRs and current heads
- read unresolved review threads, reviews, and comments from Codex
- ignore PRs with no new actionable signal
- send one agent per actionable PR/comment group
- squash-merge clean PRs after a fresh Codex thumbs-up for the current head

Use a webhook when available. Until then, a 2-minute heartbeat is fine.

## Taste

Do not obey every comment blindly. Understand the intent first.

Fix when the comment points to a real bug, regression, missing check, unclear behavior, or maintainability issue worth carrying.

Skip when the comment is stale, already handled, based on a false premise, or would make the PR worse. In the normal case, push the fix and resolve the thread silently. Comment only in an extreme case where the task is unnecessary or needs clarification; use the `onmax` account and report the exact body and URL for Maxi to review.

If a watched PR/head has no fresh Codex review signal and needs one, posting the exact nudge `@codex review` is allowed when Maxi has granted that permission for the run. Do not duplicate the nudge for the same head.

## Merge Ready PRs

Merge without waiting when the PR is authored by the current GitHub user, is not a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and the latest Codex signal is a thumbs-up or no-major-issues comment for the current head.

Use the recent repository strategy: squash merge. Delete the PR branch when GitHub allows it for same-repo branches. If any condition is missing, do not merge; report the blocker.

## Work The Queue

For each actionable item:
1. Create or use a dedicated T3 Code or Codex worktree under the configured workspace.
2. Load `workflow` and `pr-refiner`; keep one owner per PR.
3. Make the smallest fix that satisfies the intent.
4. Run focused checks.
5. Push to the PR branch.
6. Resolve addressed threads without adding a comment.
7. Remove the worktree when the branch is clean and pushed.

After a fix lands, use the merge-ready rule above. Do not merge when checks are pending or the latest Codex signal is stale.

## Script

Generate the fixed heartbeat prompt:

```sh
skills/pr-comment-sentinel/scripts/summonize-pr-comments.sh gh:vite-hub/vitehub
```

Pass more repos as extra arguments. The script only prints the prompt; use it to summonize a Codex heartbeat, T3 Code task, or manual agent run.
