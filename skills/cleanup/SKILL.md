---
name: cleanup
description: Audits and safely cleans Git worktrees, branches, build artifacts, caches, Docker data, or disk usage. Use only when the user explicitly asks to clean worktrees, reclaim disk space, or remove stale development state.
disable-model-invocation: true
argument-hint: "What should be cleaned: this repo, worktrees, or disk space?"
---

# Cleanup

Start read-only, establish ownership, and make every destructive target explicit before removing it.

## Route

- **Git worktrees and branches:** read [worktrees.md](references/worktrees.md) and [worktree-reference.md](references/worktree-reference.md).
- **Disk space, caches, media, or Docker:** read [disk.md](references/disk.md). Add the worktree references only when stale worktrees are material to the result.
- **Broad machine cleanup:** survey both branches, group candidates by safety tier, and ask before touching anything outside regenerable build artifacts and tool-owned caches.

The current repo is the default scope. Do not broaden to sibling repos, remote machines, application data, or external drives unless the user asked for that scope.

## Safety Contract

Preserve dirty or untracked work, unique commits, active-task worktrees, default branches, persistent Docker volumes, app data, and anything with uncertain ownership. Prefer recoverable deletion and tool-native cleanup commands. A request to inspect or estimate does not authorize deletion.

Report candidates and expected recovery first. After an authorized cleanup, report exactly what was removed, what remains recoverable, space reclaimed when measurable, and anything preserved because ownership or uniqueness was uncertain.
