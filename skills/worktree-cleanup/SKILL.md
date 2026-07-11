---
name: worktree-cleanup
description: Cleans Git worktrees, stale branches, and build artifacts without losing unique work. Use to clean worktrees, prune branches, reduce disk usage, or remove stale Codex workspaces.
---

# Worktree Cleanup

Use this skill to clean the current session repo by default. Only broaden to common local roots or SSH workspaces when the user or automation explicitly asks for local-machine or remote cleanup.

The goal is to reduce disk usage without losing unique work.

This skill is not an auth/setup workflow. If cleanup reveals missing GitHub, Vercel, Cloudflare, SSH, or device-login authorization, report the blocker and hand off to a setup/auth workflow instead of broadening the cleanup task. Do not turn scheduled cleanup into multi-provider login or account setup unless the user explicitly changes the task.

## Default Scope

- Manual trigger: clean the repo for the current session `cwd`.
- Automation trigger: clean common local roots and the shared VPS workspace.
- Remote cleanup: use SSH aliases such as `heztner-main`, targeting `/home/workspace` unless the user gives another path.

## Safety Rules

- Delete only clean worktrees whose checked-out branch is merged into the default branch.
- Delete local branches only when merged into the default branch, or stale and with zero commits unique from the default branch.
- Never delete default branches, checked-out branches, dirty worktrees, untracked files, or branches with unique commits.
- Never delete the current session worktree or a worktree owned by another active task. If ownership is uncertain, preserve it.
- Never delete remote branches unless the user explicitly asks in that turn.
- Treat untracked files as work. Report them; do not remove them automatically.
- If local work exists and no similar branch/commit is visible elsewhere, tell the user.
- Prefer dry-run style inspection first unless the automation is explicitly running its scheduled cleanup.

## Git Cleanup Workflow

Load [REFERENCE.md](REFERENCE.md) for the exact command recipes. For each repo in scope:

1. Refresh remote refs and capture the current branch, status including untracked files, and machine-readable worktree list.
2. Record the current session worktree and reconcile listed worktrees with active task ownership.
3. Resolve the default branch from `origin/HEAD`, then fall back to an existing `main`, `master`, or `trunk` ref.
4. Classify every worktree and local branch against the safety rules before deleting anything.

For each worktree:
- Keep the main worktree.
- Keep the current session worktree and worktrees owned by active tasks.
- Keep dirty worktrees, including untracked files.
- Keep unmerged worktrees.
- Remove only clean, unowned, non-main worktrees whose branch is an ancestor of the default branch.

For each local branch:
- Keep the default branch.
- Keep any branch checked out by a worktree.
- Delete merged branches with the safe branch-deletion command.
- Delete a stale branch only after its unique commit count is `0`.

After safe deletions, prune stale worktree metadata. Run ordinary Git GC only when repository size or disk reduction is in scope and the repo is idle.

## Disk Cleanup Workflow

Use Docker cleanup only when reducing disk usage is in scope.

Use the age-filtered container, image, and builder recipes in [REFERENCE.md](REFERENCE.md).

Do not run `docker volume prune` unless the user explicitly asks; volumes may contain databases or persistent dev state.

For build artifacts, inspect size and ignore state first. Delete generated cache directories only when they are ignored by Git or the repo is clean after deletion.

Do not delete dependency directories such as `node_modules` by default.

## SSH Cleanup Workflow

For remote cleanup, use the SSH recipe in [REFERENCE.md](REFERENCE.md) and apply the same ownership, status, merge, and uniqueness gates.

For broad remote cleanup, inspect repos under `/home/workspace`. Use one SSH alias when the workspace is shared; using all account aliases is redundant.

## Reporting

Always summarize:
- worktrees removed
- branches deleted
- Docker/artifact space cleanup attempted
- preserved dirty/untracked work
- stale unique branches that require user review
- auth or provider setup blockers that were deliberately left out of cleanup scope

If anything is preserved because it may be unique, make that the top of the report.
