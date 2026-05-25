---
name: pr-stack-coordinator
description: Coordinates stacked or related GitHub PRs across local worktrees, active Codex sessions, ADR indexes, PR bodies, and squash-merge ordering. Use when the user asks which PRs are ready to merge, asks about multiple PRs, dependent PRs, active worktrees, ADR index collisions, PR body dependency markers, or rebase/squash/merge coordination.
---

# PR Stack Coordinator

## Quick Start

Use this skill when PR readiness depends on more than one PR, branch, worktree, or local Codex session.

Default posture: read-only first. The first pass may inspect local repositories, active sessions, worktrees, GitHub PR metadata, PR bodies, changed files, commit ancestry, checks, and ADR files. It must not edit files, push branches, update PR bodies, comment, resolve threads, approve, close, merge, or force-push.

After the read-only pass, mutate only the exact actions the user explicitly approves.

## Workflow

1. Resolve the repository, default branch, remote, and requested PR scope.
2. Map active Codex sessions before considering mutation. Use `codex-session-finder` when the user mentions active sessions, previous threads, or unclear worktree ownership. Treat active or uncertain worktrees as unsafe for mutation.
3. Query GitHub open PRs for matching branches with `gh pr list` and `gh pr view`.
4. Build a stack graph from base branches, head branches, commit ancestry, changed files, branch names, and existing PR body dependency or coordination notes.
5. Classify each relationship as `blocked`, `coordination`, `independent`, or `unknown`.
6. Scan likely ADR directories when a PR changes ADR-like files. Detect duplicate numeric indexes across open PR branches, local worktrees, and the target base. Recommend the next available index on top of the target base branch. Update ADR filenames or references only after explicit approval.
7. Identify PRs unsafe to mutate because their branch belongs to an active or uncertain worktree.
8. Build a stack evidence packet for each candidate PR: base/head branch, parent/child PRs, review-thread state, checks, active worktree risk, ADR index risk, Pre-Merge Gate state, and the current user-approved next action.
9. Before recommending or executing a merge, classify the Pre-Merge Gate for each candidate PR as `required`, `skip`, `stale`, or `blocked`. Use `pre-merge-validation` when a PR has consumer-facing package, runtime, provider, generated-output, docs-as-contract, or recent post-merge defect risk.
10. Run `validate-direction` before recommending merge, rebase, dependency marker, ADR index, or PR body coordination actions when the stack implies a new project direction, API, ADR, implementation plan, or cross-PR ownership boundary.
11. Produce an ordered readiness report and proposed actions.
12. For code-level fixes inside one PR, hand off to `pr-refiner` and include the stack evidence packet.

## PR Body Guidance

Follow the repository PR template if present. Check `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md`, `CONTRIBUTING.md`, and recent merged PRs when the style is unclear.

If there is no template, prefer one to three natural paragraphs that explain what changed, why it exists, and reviewer-relevant context. Add links to issues, docs, ADRs, or related PRs when they reduce maintainer effort.

Do not invent boilerplate headings such as `## Summary`. Do not add `Validation`, `Tests`, or internal check-log sections unless the repository template or user explicitly asks for them. Keep commands run in the final chat summary, not the PR body.

Use structured sections only when they carry operational meaning, such as merge dependency or coordination notes.

## Dependency Markers

Add or update PR body dependency markers only after explicit approval.

Use a hard dependency marker when a PR must not merge until another PR lands or the branch is rebased. Use coordination language when PRs touch the same conflict-prone surface but can merge independently.

Preserve existing repository wording when it is already clear.

## Merge Commands

Support command-style requests such as `merge PR 152`, `merge ready PRs`, `squash merge PR 152 after rebase`, and `rebase, squash, and merge PR 152`.

Treat merge commands as consent to prepare a merge plan, not consent to execute it.

Before any merge, verify the PR is open and not draft, hard dependencies are resolved, dependency or coordination notes are reflected in PR bodies when needed, ADR indexes are unique when ADRs changed, required checks are passing or explicitly accepted, unresolved review threads and requested changes are absent or explicitly accepted by the user after being shown, the branch is not owned by an active or uncertain Codex worktree, the requested rebase or branch update is complete, any needed `validate-direction` verdict is `proceed` or its required changes are reflected in the plan, the Pre-Merge Gate is `pass` or justified `skip`, and the final squash commit follows Conventional Commits with the PR reference.

For batch merges, present an ordered plan but request confirmation per PR before executing each merge.

Confirmation must include the exact final commit title and body.

### Final Review State Gate

Immediately before asking for merge confirmation, refetch the candidate PR's review state. Do not rely on earlier inspection from the same session.

Required final facts:
- unresolved review thread count and touched files
- latest review decision and requested changes
- top-level comments created after the last inspection that contain blocking language
- current status check conclusion and required-check state

If unresolved review threads, requested changes, new blocking comments, failing required checks, or unknown review-thread state remain, classify the PR as blocked. Show the blocker and route to `pr-refiner` unless the user explicitly accepts that exact blocker and repository policy allows it. A generic CI-green or approved signal is not enough when review-thread state is unknown.

## Pre-Merge Validation

Use `pre-merge-validation` as an adaptive final gate for PRs that could pass repository-local checks but fail when installed by a real consumer.

Require it when changed files, PR text, or recent defects indicate public package behavior, exports, docs/examples as usage contracts, runtime or provider wiring, generated output, or package artifact risk. Skip it with a concrete reason for docs-only, ADR-only, lint-only, dead-code-only, or purely internal changes already proven by existing checks.

Before final merge confirmation, report whether the gate is `pass`, `skip`, `stale`, `fail-pr`, `fail-repro`, or `blocked`. Proceed only on `pass` or justified `skip`; otherwise route code defects to `pr-refiner` or ask for the needed validation action.

## CLI Guidance

Prefer `gh` and `git` for deterministic state. See [REFERENCE.md](REFERENCE.md) for command examples, dependency marker examples, and merge confirmation examples.

Do not post PR or issue comments without explicit consent.

## Output

```md
PR stack:
- #...
Stack evidence:
- #... base/head, reviews, checks, worktree, ADR, dependency, and pre-merge state
Ready:
- #...
Blocked:
- #... blocked by #...
Coordination:
- #... coordinates with #...
ADR index issues:
- ...
Pre-Merge Gates:
- #... pass | skip | stale | fail-pr | fail-repro | blocked
Unsafe to mutate:
- ...
Proposed actions:
- ...
Needs approval:
- ...
```

## Rules

- Read-only first.
- Never merge, close, approve, comment, force-push, edit PR bodies, edit files, or push without explicit approval.
- Never mutate an active or uncertain Codex worktree.
- Distinguish hard dependencies from merge coordination.
- Treat consumer-facing pre-merge validation as a merge gate, not as merge consent.
- Use `validate-direction` as a late-stage check before acting on stack-level recommendations that could crystallize a weak or premature direction.
- Keep PR body prose natural and template-compatible.
- Keep `pr-refiner` focused on individual PR code fixes.
