---
name: file-a-pr
description: "Files one concise GitHub pull request from a completed change. Use when the user explicitly asks to file, open, create, or update a PR from the current branch."
disable-model-invocation: true
argument-hint: "Optional base branch and draft or ready preference"
---

# File a PR

Publish one completed change as a reviewer-ready PR, then stop. Use `pull-request` for later review, CI, conflict, or merge work.

## Authority

A filing request authorizes scoped verification, commits, an ordinary push, and creating the PR or replacing the title and body of the same branch's existing PR. Stage explicit paths and preserve ambient changes.

Comments, review requests, optional metadata, merging, deployment, rebasing, force-pushing, and history rewriting require separate consent. Repository-required publication metadata is part of filing.

## File the PR

1. Resolve the repository, branch, base, worktree ownership, dirty state, exact diff, repository instructions, and PR template. Update an existing PR for this branch; stop on uncertain ownership, secrets, inseparable changes, or overlap with another PR.
2. Reconcile the diff and commits with the original goal, or infer the goal from the linked task and existing PR while naming that limit. Use `code-review`; a finding that changes behavior, risk, scope, or the review decision requires a draft unless publication itself is unsafe.
3. Verify the source head with the narrowest relevant checks. Link current proof. If a preview tests a synthetic merge commit, record both SHAs; qualify claims without linked or independently verified evidence.
4. Follow repository title conventions, otherwise use a concise conventional-commit title naming the outcome. Use `engineering-writing` for a problem-first body. Choose evidence for the review decision: before/after states for comparison, the complete output contract for coverage, and varied screenshots for distinct visual states.
5. Commit scoped files if needed, push normally, and create or update the PR. Use draft state while checks, changed paths, temporary pins, migration order, or hard dependencies remain unresolved; otherwise follow user intent and repository convention, defaulting to ready.
6. Re-fetch the PR and verify its URL, base, head, title, body, and draft state. Return the URL, state, current-head proof, blockers, skipped checks, and actions still needing consent.

## Body Taste

Replace the agent pattern seen across PR #896, #904, and #906:

> ## Improvements / Summary
> - Persists Better Auth users, sessions, accounts...
> - rewrite Stock Out detail-panel descriptions...
> - enforce a five-word ceiling...
>
> ## Verification
> - `git diff --check`
> - Exact-head CI: lint, typecheck, Knip...

This inventory makes reviewers reconstruct the problem, outcome, and readiness.

For a comparison, write like PR #904:

> Simplifies the detail copy for both Stock Out and Stock Out Risk alerts and highlights how long each item remains exposed.
>
> ## Before and now
> | Scenario | Before | Now |
> | --- | --- | --- |
> | Stock Out Risk — with PO | Stock-out risk starts in 2 days... | Stock is expected to fall below safety stock in 2 days... |

Cover each materially different branch and place its screenshot beside it.

For coverage, write like PR #906:

> Replace verbose alert descriptions with one concise key value per alert type while preserving product identity and full detail descriptions.
>
> ## Alert list values
> - Stock Out: `Out for 1.332 days`
> - Stock Out Risk: `Starts in 3 days`
> - Late Shipment: `PO 4500123 is overdue`

Enumerate the complete contract, then prove representative states and edge behavior with a preview and screenshots.
