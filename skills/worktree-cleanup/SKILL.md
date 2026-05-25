---
name: worktree-cleanup
description: Safely cleans local and SSH Git worktrees, stale branches, and accumulated build/Docker artifacts without losing unique work. Use when the user asks to clean worktrees, prune branches, reduce disk usage, remove stale Codex workspaces, or set up recurring cleanup.
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
- Never delete remote branches unless the user explicitly asks in that turn.
- Treat untracked files as work. Report them; do not remove them automatically.
- If local work exists and no similar branch/commit is visible elsewhere, tell the user.
- Prefer dry-run style inspection first unless the automation is explicitly running its scheduled cleanup.

## Git Cleanup Workflow
For each repo in scope:

```sh
git fetch --all --prune
git remote set-head origin -a 2>/dev/null || true
git branch --show-current
git status --porcelain=v1 -uall
git worktree list --porcelain
```

Infer the default branch from `origin/HEAD`, then fall back to `main`, `master`, or `trunk`.

For each worktree:
- Keep the main worktree.
- Keep dirty worktrees, including untracked files.
- Keep unmerged worktrees.
- Remove only clean non-main worktrees whose branch is an ancestor of the default branch:

```sh
git merge-base --is-ancestor <branch> <default-ref>
git worktree remove <path>
```

For each local branch:
- Keep the default branch.
- Keep any branch checked out by a worktree.
- Delete merged branches with `git branch -d <branch>`.
- For stale branches, check age and uniqueness before deleting:

```sh
git log -1 --format=%ct <branch>
git rev-list --count <default-ref>..<branch>
```

Delete stale branches only when unique commit count is `0`.

After safe deletions:

```sh
git worktree prune
git gc --prune=now
```

## Disk Cleanup Workflow
Use Docker cleanup only when reducing disk usage is in scope.

Safe Docker cleanup:

```sh
docker container prune -f --filter until=168h
docker image prune -f --filter until=168h
docker builder prune -f --filter until=168h
```

Do not run `docker volume prune` unless the user explicitly asks; volumes may contain databases or persistent dev state.

For build artifacts, prefer deleting generated cache directories only when they are ignored by Git or the repo is clean after deletion. Inspect first:

```sh
git check-ignore -v .next/cache node_modules/.cache dist build target 2>/dev/null || true
du -sh .git .next/cache node_modules/.cache dist build target 2>/dev/null || true
```

Do not delete dependency directories such as `node_modules` by default.

## SSH Cleanup Workflow
For remote cleanup, run the same inspection over SSH:

```sh
ssh heztner-main 'cd /home/workspace/<repo> && git status --porcelain=v1 -uall && git worktree list --porcelain'
```

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

See [REFERENCE.md](REFERENCE.md) for command patterns and decision checks.
