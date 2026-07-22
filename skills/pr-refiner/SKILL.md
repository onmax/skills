---
name: pr-refiner
description: Refines one GitHub PR toward review or merge readiness. Use to check a PR, address review comments, inspect CI, reduce scope, or identify remaining blockers.
---

# PR Refiner

## Quick Start

Use this skill when the user wants a PR moved from "has feedback" to "ready for the next reviewer action."

First classify the user's intent under the mutation contract. Keep the run scoped to one PR.

## Mutation Contract

- Read-only intent: `check`, `review`, `status`, `inspect`, or bare `$pr-refiner <number-or-url>`. Inspect and report without changing local files, git history, the branch, or GitHub state.
- Refinement intent: `refine`, `fix`, `address`, or equivalent explicit action language. Make scoped local edits, run relevant checks, commit, push ordinarily to the existing PR branch, and silently resolve a review thread only after the pushed code demonstrably addresses it.
- Separate consent: comments or replies, PR body edits, labels, closing, merging, force-pushing, approvals or request-changes reviews, ambiguous or unverified thread resolution, and the merge, rebase, or rewrite history strategy.

Consent for one mutation class does not authorize another.

## Workflow

1. Resolve one PR: explicit URL or number first, otherwise the current branch PR. Record the user's read-only or refinement intent.
2. Run the coordination checks before editing.
3. Inspect the PR state:
   - title, body, base/head branches, changed files, and local uncommitted changes
   - review decision, unresolved review threads, top-level comments, and requested changes
   - CI/check status, conflicts, mergeability, and branch freshness
   - whether the PR is stacked and which diff range represents only this PR's own changes
4. Classify blockers and each proposed action against the mutation contract.
5. For read-only intent, stop after reporting status, blockers, and the next useful action.
6. For refinement intent, route each blocker to the smallest scoped fix, including related local changes.
7. Run the narrow checks that prove the fixes.
8. Commit and ordinarily push the existing PR branch. Batch related fixes when CI, deploy previews, or reviewer notifications are costly.
9. Apply only the thread resolutions authorized by the mutation contract.
10. Report the resulting PR status and any action still needing consent.

## Onmax Skill Routing

- Use `simplify` when the PR feels too broad, has accidental complexity, or needs concrete path-based simplification suggestions.
- Use `validate-direction` when a requested change would harden a new direction, API, ADR, or implementation plan.
- Use `evidence-research` only when internal or external evidence would change the PR decision.
- Use `handoff` when the PR cannot be finished in the current session.
- Use `grill-with-docs` only when the user explicitly requests a documented grilling artifact. Create durable project documentation only when the user explicitly requests that artifact.

## Blocker Routing

- Review comments, including Codex or AI comments: inspect thread-aware state and follow the mutation contract.
- Failing checks: inspect logs and identify the root cause before proposing a fix.
- Conflicts or stale branch: follow the conflict and freshness gate before mutation.
- Unclear product or domain feedback: ask one concise question or use `validate-direction` when the choice would harden a direction.
- Overbroad PR: run `simplify` before editing.

## Conflict and Freshness Gate

When the branch is stale or conflicted, run this gate before editing files or mutating the branch, even when the user also requested code fixes:

1. Show how many commits the PR adds over its base and how many commits the head is behind the base.
2. Explain the consequence of merging the base into the head, rebasing the head onto the base, or rewriting the head for commit identity, review range, and whether a force-push would follow.
3. Obtain separate consent for the history strategy, then execute only that strategy.

## GitHub GraphQL Review Threads

Use GitHub GraphQL when resolving inline review threads, especially Codex threads. Load [github-graphql.md](github-graphql.md) for `gh api graphql` commands that fetch unresolved `PullRequestReviewThread` nodes and resolve them with `resolveReviewThread`.

## Guardrails

- Do not treat top-level comments as complete thread state.
- Do not churn code while a pending AI review may still change the requested direction unless the existing blocker is already clear.
- Avoid push churn: do not push every micro-fix when a local batch can prove several review fixes together.
- Keep each local edit traceable to one blocker.

## Coordination Checks

Stay in this skill only when one PR can be refined independently.

Stop before editing when the PR appears stacked, depends on another PR, shares conflict-prone files with nearby PRs, changes ADR indexes, needs a merge-order decision, or belongs to an active or uncertain Codex worktree.

If the PR only exists as part of a stack, challenge whether it should instead be independent against the default branch, merged after its dependency, or combined with its dependency. Do not preserve a stack just because it already exists.

If the user explicitly asks to refine only the top item in a stack, do not inspect or fix `main...HEAD` wholesale. Use the PR's actual base branch, explicit commit range, or `HEAD^..HEAD` when that is the user's scoped range, and report that parent-stack findings are out of scope.

When a PR changes ADR-like files, check for numeric index collisions against the base branch and nearby open PRs before pushing. If a collision exists, do not rename files silently; report the collision.

## PR Body Edits

After consent under the mutation contract, use `engineering-brief` for repository style, issue linking, evidence, and body content rules.

## Output

```md
PR status:
- ...

Blockers:
- ...

Recommended next step:
- ...

Needs approval:
- ...
```
