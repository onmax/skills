---
name: pull-request
description: "Reviews and converges one existing GitHub pull request: contribution fit, code quality, CI, feedback, conflicts, and merge readiness. Use only when the user explicitly asks to inspect, review, refine, fix, or finish an existing PR."
disable-model-invocation: true
argument-hint: "PR URL or number, plus inspect, review, refine, or finish"
---

# Pull Request

Move one existing PR toward a clear reviewer or merge decision. This skill does not create PRs, deploy previews, merge, or publish releases.

## Intent And Authority

- `inspect`, `check`, `review`, a URL, or a bare PR number is read-only.
- `refine`, `fix`, `address`, or `finish` authorizes scoped local edits, relevant checks, commits, and an ordinary push to the existing PR branch.
- Comments and replies, PR body edits, labels, reviews, thread resolution, branch deletion, merging, force-pushing, rebasing, or rewriting history require separate explicit consent.

Consent can come from the initial request or a later message in ordinary language. Once granted, it remains valid for that PR and mutation class throughout the current task; act on it without asking again. Reconfirm only when the PR changes, the action belongs to a different mutation class, the scope or risk materially changes, or the user made consent conditional or withdrew it.

One mutation class never implies another. For example, consent to reply to reviewers covers the scoped replies requested for that PR, but it does not authorize merging it.

## Route

1. Resolve the repository, PR, base/head branches, current worktree ownership, dirty state, and the diff that belongs only to this PR.
2. Read [contribution-review.md](references/contribution-review.md) when contribution fit, upstream ownership, or patch minimality is in question.
3. Use `code-review` for code and spec findings. Use `ponytail:ponytail` when the implementation needs a smaller solution.
4. Read [convergence.md](references/convergence.md) for review threads, CI, blockers, batching, and readiness.
5. Read [merge-conflicts.md](references/merge-conflicts.md) before proposing a conflict or freshness strategy. Explain merge, rebase, and rewrite consequences, then proceed under existing consent or ask once when it is absent.
6. Use [github-graphql.md](references/github-graphql.md) only for inline review-thread state or an authorized resolution.

For refinement intent, implement only verified blockers, run the narrow proof, and avoid notification or CI churn by batching related fixes. Resolve a thread only after the pushed code demonstrably addresses it and the mutation is authorized.

## Stop Conditions

Stop before editing when the PR is stacked, shares conflict-prone files with active work, changes ordered indexes, has uncertain worktree ownership, or depends on a merge-order decision. Report the exact coordination choice needed.

## Output

Lead with the current PR status. Separate contribution-fit findings, code/spec findings, CI or review blockers, actions completed, and actions that still need consent. Link to exact proof when it exists.
