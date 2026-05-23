---
name: pr-refiner
description: Reviews and refines GitHub pull requests until they are ready for review or merge. Use when the user asks to check a PR, refine a PR, address review comments, resolve Codex comments, inspect CI, reduce PR scope, or decide what still blocks merge.
---

# PR Refiner

## Quick Start

Use this skill when the user wants a PR moved from "has feedback" to "ready for the next reviewer action."

Example trigger: `pr-refiner https://github.com/owner/repo/pull/123`

Default posture: autonomous refinement. An explicit `pr-refiner` invocation for a PR is consent to inspect, implement scoped fixes, run relevant checks, push the PR branch, and resolve review threads that are verified addressed.

It is not consent to post PR comments, approve, request changes, label, close, merge, force-push, or resolve ambiguous/unverified threads.

For multiple PRs, stacked PRs, merge ordering, active worktree coordination, ADR index collisions, dependency markers, or rebase/squash/merge execution, use `pr-stack-coordinator` instead.

## Workflow

1. Resolve the PR scope: explicit PR URL/number first, otherwise current branch PR.
2. Inspect the PR state:
   - title, body, base/head branches, changed files, and local uncommitted changes
   - review decision, unresolved review threads, top-level comments, and requested changes
   - CI/check status, conflicts, mergeability, and branch freshness
3. Classify blockers before changing anything.
4. Route each blocker to the smallest useful fix.
5. Implement fixes that are part of the PR scope, including related local changes.
6. Run the narrow checks that prove the fixes.
7. Commit and push the PR branch when changes are ready.
8. Resolve review threads only after the pushed code demonstrably addresses them.
9. End with a concise PR status summary.

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
- Prefer resolving addressed Codex threads silently instead of replying when no explanation is needed.
- Do not treat top-level comments as complete thread state.
- Do not churn code while a pending AI review may still change the requested direction unless the existing blocker is already clear.
- Keep each local edit traceable to one blocker.

## PR Body Edits

Follow the repository PR template if present. Without a template, prefer concise natural prose that explains what changed, why it exists, and reviewer-relevant context.

Do not invent boilerplate headings such as `## Summary`. Do not add `Validation`, `Tests`, or internal check-log sections unless the repository template or user explicitly asks. Include links to issues, docs, ADRs, or related PRs when they reduce reviewer effort.

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
