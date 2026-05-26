---
name: pr-refiner
description: Refines one GitHub PR toward review or merge readiness. Use to check a PR, address review comments, inspect CI, reduce scope, or identify remaining blockers.
---

# PR Refiner

## Quick Start

Use this skill when the user wants a PR moved from "has feedback" to "ready for the next reviewer action."

Example trigger: `pr-refiner https://github.com/owner/repo/pull/123`

Default posture: autonomous refinement. An explicit `pr-refiner` invocation for a PR is consent to inspect, implement scoped fixes, run relevant checks, push the PR branch, and resolve review threads that are verified addressed.

It is not consent to post PR comments, approve, request changes, label, close, merge, force-push, or resolve ambiguous/unverified threads.

For multiple PRs, stacked PRs, merge ordering, active worktree coordination, ADR index collisions, dependency markers, or rebase/squash/merge execution, use `pr-stack-coordinator` instead.

When `pr-stack-coordinator` hands off a PR, preserve its stack evidence packet. Do not discard cross-PR blockers just because the current fix is local; either resolve them within the handoff scope or report them as still owned by `pr-stack-coordinator`.

## Workflow

1. Resolve the PR scope: explicit PR URL/number first, otherwise current branch PR.
2. Inspect the PR state:
   - title, body, base/head branches, changed files, and local uncommitted changes
   - review decision, unresolved review threads, top-level comments, and requested changes
   - CI/check status, conflicts, mergeability, and branch freshness
   - whether the PR is stacked and which diff range represents only this PR's own changes
   - any stack evidence packet passed from `pr-stack-coordinator`
3. Classify blockers before changing anything.
4. Before mutating anything, classify the next action as one of: local edit, branch push, review-thread resolution, PR body edit, label change, close, merge, force-push, or comment.
5. Route each blocker to the smallest useful fix.
6. Implement fixes that are part of the PR scope, including related local changes.
7. Run the narrow checks that prove the fixes.
8. Commit and push the PR branch when changes are ready. Batch related review fixes into one push when CI, deploy previews, or reviewer notifications are costly.
9. Resolve review threads only after the pushed code demonstrably addresses them.
10. End with a concise PR status summary.

## Onmax Skill Routing

- Use `simplify` when the PR feels too broad, has accidental complexity, or needs concrete path-based simplification suggestions.
- Use `grill-with-docs` when review feedback changes project language, domain meaning, or ownership boundaries.
- Use `validate-direction` when a requested change would harden a new direction, API, ADR, or implementation plan.
- Use `evidence-research` only when internal or external evidence would change the PR decision.
- Use `handoff` when the PR cannot be finished in the current session.
- Use `fast-forward` only inside a grilling flow to skip obvious branches.
- Use `pr-stack-coordinator` when the request involves multiple PRs, dependent PRs, ADR index collisions, active worktree safety, PR body dependency markers, or merge execution.

## Blocker Routing

- Review comments: inspect thread-aware review state before editing.
- Codex or AI review comments: verify the code addresses the thread, implement if needed, push, then resolve the thread silently when verified addressed.
- Failing checks: inspect logs and identify the root cause before proposing a fix.
- Conflicts or stale branch: explain the narrow update path before changing files.
- Unclear product/domain feedback: ask one question or route through `grill-with-docs`.
- Overbroad PR: run `simplify` before editing.

## GitHub GraphQL Review Threads

Use GitHub GraphQL when resolving inline review threads, especially Codex threads. Load [github-graphql.md](github-graphql.md) for `gh api graphql` commands that fetch unresolved `PullRequestReviewThread` nodes and resolve them with `resolveReviewThread`.

## Guardrails

- Treat explicit `pr-refiner` invocation as consent to push scoped PR fixes and resolve verified addressed review threads.
- Never post PR comments without explicit user consent.
- Do not treat consent for local edits or branch pushes as consent for PR body edits, labels, closing, merging, force-pushing, comments, approvals, or ambiguous thread resolution.
- Prefer resolving addressed Codex threads silently instead of replying when no explanation is needed.
- Do not treat top-level comments as complete thread state.
- Do not churn code while a pending AI review may still change the requested direction unless the existing blocker is already clear.
- Avoid push churn: do not push every micro-fix when a local batch can prove several review fixes together.
- Keep each local edit traceable to one blocker.

## Coordination Checks

Stay in this skill only when one PR can be refined independently.

Hand off to `pr-stack-coordinator` before editing when the PR appears stacked, depends on another PR, shares conflict-prone files with nearby PRs, changes ADR indexes, needs a merge-order decision, or belongs to an active or uncertain Codex worktree.

If the PR only exists as part of a stack, challenge whether it should instead be independent against the default branch, merged after its dependency, or combined with its dependency. Do not preserve a stack just because it already exists.

If the user explicitly asks to refine only the top item in a stack, do not inspect or fix `main...HEAD` wholesale. Use the PR's actual base branch, explicit commit range, or `HEAD^..HEAD` when that is the user's scoped range, and report that parent-stack findings are out of scope.

When a PR changes ADR-like files, check for numeric index collisions against the base branch and nearby open PRs before pushing. If a collision exists, do not rename files silently; report the collision and route through `pr-stack-coordinator`.

## PR Body Edits

Follow the repository PR template if present. Without a template, prefer concise natural prose that explains what changed, why it exists, and reviewer-relevant context.

Do not invent boilerplate headings such as `## Summary`. Do not add `Validation`, `Tests`, or internal check-log sections unless the repository template or user explicitly asks. Include links to issues, docs, ADRs, or related PRs when they reduce reviewer effort.

## Output

```md
PR status:
- ...

Stack evidence:
- ...

Blockers:
- ...

Recommended next step:
- ...

Needs approval:
- ...
```
