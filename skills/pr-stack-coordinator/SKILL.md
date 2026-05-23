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
8. Produce an ordered readiness report and proposed actions.
9. For code-level fixes inside one PR, hand off to `pr-refiner`.

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

Before any merge, verify the PR is open and not draft, hard dependencies are resolved, ADR indexes are unique when ADRs changed, required checks are passing or explicitly accepted, the branch is not owned by an active or uncertain Codex worktree, the requested rebase or branch update is complete, and the final squash commit follows Conventional Commits with the PR reference.

For batch merges, present an ordered plan but request confirmation per PR before executing each merge.

Confirmation must include the exact final commit title and body.

## CLI Guidance

Prefer `gh` and `git` for deterministic state. See [REFERENCE.md](REFERENCE.md) for command examples, dependency marker examples, and merge confirmation examples.

Do not post PR or issue comments without explicit consent.

## Output

```md
PR stack:
- #...
Ready:
- #...
Blocked:
- #... blocked by #...
Coordination:
- #... coordinates with #...
ADR index issues:
- ...
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
- Keep PR body prose natural and template-compatible.
- Keep `pr-refiner` focused on individual PR code fixes.
