---
name: pr-comment-sentinel
description: Watches GitHub PR comments and review threads, fixes actionable Codex feedback, and squash-merges clean authored PRs after a fresh Codex thumbs-up or explicit quota fallback subagent review. Use when setting up passive PR comment handling, a PR heartbeat, or an automated review-fix loop for repositories such as gh:vite-hub/vitehub.
---

# PR Comment Sentinel

A comment has arrived. It might be a bug, a misunderstanding, or noise. This skill keeps a small **queue** of open PRs, reads Codex feedback for intent, and turns only actionable comments into patches.

The default repo is `gh:vite-hub/vitehub`. Add more repos in the script call, not in the skill text.

## The Queue

The queue is all open PRs in the watched repos where the current GitHub user is the author.

Each heartbeat:
- list open PRs and current heads
- run one bounded single pass; do not watch pending checks or wait for spawned fix workers
- load `workflow`; the root is a coordinator only, with one independent lane and one owner per PR
- use metadata-only list calls first; never call `gh pr list --json comments,reviews,statusCheckRollup`
- process clean merge-ready PRs in the listed repo order before deep-inspecting blocked or stale PRs
- read unresolved review threads, reviews, and comments from Codex
- read PR-level reactions from Codex with GraphQL; a `THUMBS_UP` from `chatgpt-codex-connector[bot]` after the latest commit counts as a fresh Codex signal for the current head
- before marking ready or merging, run `scripts/codex-command-blocker.sh <owner/repo> <pr> <current-head>`; a newer `@codex` command after the latest commit makes older thumbs-up and fallback evidence stale until a newer Codex bot review or `THUMBS_UP` exists for that head
- use `gh api graphql` for review threads; `gh pr view --json reviewThreads` is not a valid field
- ignore PRs with no new actionable signal unless they satisfy merge-ready preconditions
- treat Codex code-review usage-limit comments as review-unavailable state
- start all ready or actionable PR lanes before waiting on any lane
- send one owner per actionable PR/comment group; a lane is not spawned unless it has a durable child-thread id that can be polled or an OS worker with a pid file and log path
- squash-merge clean PRs after a fresh Codex thumbs-up or allowed internal fallback subagent review for the current head
- keep merge gates per PR; do not let pending checks or blocked state in one repo delay an unrelated PR whose own merge conditions are satisfied
- draft status is not a terminal blocker for authored PRs; mark otherwise-ready authored drafts ready for review, then re-check before merging
- report pending checks, running workers, and blocked PRs, then exit so the next timer run re-lists the queue

Use a webhook when available. Until then, a 2-minute heartbeat is fine.

## Taste

Do not obey every comment blindly. Understand the intent first.

Fix when the comment points to a real bug, regression, missing check, unclear behavior, or maintainability issue worth carrying.

Skip when the comment is stale, already handled, based on a false premise, or would make the PR worse. In the normal case, push the fix and resolve the thread silently. Comment only in an extreme case where the task is unnecessary or needs clarification; use the `onmax` account and report the exact body and URL for Maxi to review.

If a watched PR/head has no fresh Codex review signal and needs one, posting the exact nudge `@codex review` is allowed when Maxi has granted that permission for the run. Do not duplicate the nudge for the same head.

If Codex replies that code-review usage limits were reached, treat the current head as review-unavailable. Do not post another `@codex review` for that head, do not try to switch Codex or ChatGPT accounts, and do not copy, move, or inspect auth material to bypass the limit.

Before working the fix queue, evaluate merge-ready PRs first. Check PR-level Codex reactions before fallback review. If a `chatgpt-codex-connector[bot]` `THUMBS_UP` reaction was created after the latest commit on the current head, use it as the fresh GitHub Codex signal and do not start fallback review for that PR. When the normal merge conditions are otherwise satisfied but the only missing condition is a fresh GitHub Codex review or reaction signal, run a bounded internal fallback review instead of posting to the PR. The fallback review must be carried out by a separate observable review owner; do not self-review locally in the heartbeat. A review owner is real only when the heartbeat records a pollable child-thread id or an observable read-only OS review worker with pid, log, prompt, and status paths. Ask the reviewer to review the PR diff against base for correctness, behavior regressions, security issues, missing tests, and mismatch with the PR intent, then return one internal verdict: `no-major-issues`, `needs-fix`, or `inconclusive`.

If a human posts `@codex review`, `@codex address`, or any other `@codex` command after the latest commit, do not treat older Codex reactions, older Codex reviews, or internal fallback review verdicts as merge-ready evidence. The command means the external Codex bot has a newer requested lane. Wait for a Codex bot review or PR-level `THUMBS_UP` reaction that is newer than that command, then re-check the normal merge gates.

An internal fallback verdict is not a GitHub Codex thumbs-up. It may replace the fresh GitHub Codex signal when comments are disabled or Codex review is unavailable, but only when it came from the observable review owner, the verdict is for the exact current head SHA, the PR is authored by the current GitHub user, has a Conventional Commits title, is not a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and no commits were pushed after the fallback review. If a review owner cannot be created or does not return `no-major-issues` for the current head, do not merge; report the blocker.

When a worker pushes a fix, the earlier fallback verdict is stale. After the updated head has clean checks and no unresolved current review threads, run a fresh fallback review for that exact head and then apply the merge-ready rule. Do not wait for other PRs or repos before merging a PR whose own gates have passed.

The heartbeat is not a long-running coordinator. Do not run `gh pr checks --watch`, sleep/poll loops, or `collab: Wait` for spawned fix workers or pending checks. If a PR is not ready now, report the blocker and exit; the timer will re-run and re-list all open PRs. A bounded internal fallback review for an already merge-ready PR is allowed, but if it cannot return during this pass, record `inconclusive` and exit.

Workflow lane rule: one PR equals one lane and one owner. The root may reconcile, spawn, steer, and verify short read-only state, but it must not implement fixes or sit waiting for one lane while other lanes are ready when real worker capability exists. Create a lane ledger with PR number, head SHA, owner, state, and blocker. Launch independent fix/review/merge-ready lanes in parallel before doing deep work on any single PR. A claimed owner is real only when the heartbeat records a pollable child-thread id or an observable OS worker pid and log path; otherwise it is not spawned.

Worker fallback rule: if durable child-thread tools are unavailable, launch a detached per-PR Codex worker process from the PR worktree and immediately verify that its pid exists. Record the worker prompt path, log path, pid file, and launch result in the lane ledger. The worker should leave its worktree, log, pid, and status marker in place; a later heartbeat cleans them after reading the result. If a worker exits with local diffs but no status marker, continue that same worktree in a follow-up worker instead of discarding or restarting from scratch. If an OS worker cannot be launched and verified, process at most one actionable PR lane inline in that heartbeat, then report that parallel workers were unavailable. Do not report "spawned worker" for a lane that has no pollable child id and no live pid/log.

Query discipline: first run metadata-only `gh pr list` for each repo with number, title, author, head, draft, merge state, updated time, and URL only. Do not fetch comments, reviews, full check rollups, or review threads for non-authored, dirty, blocked, draft, or stale PRs. For authored clean/non-draft candidates, fetch only that PR's checks, review threads, latest commit, and PR-level reactions, then merge or record the exact blocker before moving to broad comment inspection.

## PR Titles

Before handing off, pushing to, or merging a watched PR, confirm the PR title follows Conventional Commits: `<type>(<scope>)?: <subject>`, for example `fix(agent): honor webhook runtimes`.

If the title does not match and the correct title is clear from the PR, rename it with `gh pr edit --title`. If the correct title is not clear, do not merge; report the title blocker.

## Merge Ready PRs

If a PR is authored by the current GitHub user, has a Conventional Commits title, is a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and either the latest Codex signal is a thumbs-up/no-major-issues signal for the current head or an allowed internal fallback subagent review returned `no-major-issues` for the current head, mark it ready for review with `gh pr ready`. Then immediately re-read the PR head, draft state, checks, and review threads before deciding merge readiness.

Merge without waiting when `scripts/codex-command-blocker.sh <owner/repo> <pr> <current-head>` exits 0 and the PR is authored by the current GitHub user, has a Conventional Commits title, is not a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and either the latest Codex signal is a thumbs-up/no-major-issues signal for the current head, a PR-level Codex bot thumbs-up reaction was created after the latest commit, or an allowed internal fallback subagent review returned `no-major-issues` for the current head.

Use the recent repository strategy: squash merge. Delete the PR branch when GitHub allows it for same-repo branches. If any condition is missing, do not merge; report the blocker.

## Work The Queue

For each actionable item:
1. Create or use a dedicated T3 Code or Codex worktree under the configured workspace.
2. Load `workflow` and `pr-refiner`; keep one owner per PR.
3. Make the smallest fix that satisfies the intent.
4. Preserve or repair the PR title so it follows Conventional Commits.
5. Run focused checks.
6. Push to the PR branch.
7. Resolve addressed threads without adding a comment.
8. Remove the worktree when the branch is clean and pushed, except detached sentinel workers should leave their worktree and log for the next heartbeat to inspect.

After a fix lands, use the merge-ready rule above for that PR only when its own checks are already settled in the current pass. Do not merge when that PR has pending checks or the latest Codex signal is stale. Do not watch checks or block one ready PR on another PR that is still pending, failing, conflicted, or review-blocked.

## Script

Generate the fixed heartbeat prompt:

```sh
skills/pr-comment-sentinel/scripts/summonize-pr-comments.sh gh:vite-hub/vitehub
```

Pass more repos as extra arguments. The script only prints the prompt; use it to summonize a Codex heartbeat, T3 Code task, or manual agent run.
