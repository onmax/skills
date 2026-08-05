# Worktree Cleanup Reference

## Scope Selection

Manual cleanup should start with the current session repo:

```sh
git rev-parse --show-toplevel
```

Automation may broaden to these roots when they exist:

```text
~/Documents/Codex
~/.codex/worktrees
~/onmax
~/vitehub
/home/workspace on the VPS
```

Do not assume every path exists. Check first.

## Repo Discovery

Use `find` carefully and skip common heavy directories:

```sh
find <root> \
  \( -type d \( -name node_modules -o -name .next -o -name dist -o -name build -o -name target \) \) -prune \
  -o -name .git -print -prune
```

This finds both `.git` directories and linked-worktree `.git` files without descending into them. For each entry, resolve the parent directory's top-level repo:

```sh
git -C <parent-of-git-entry> rev-parse --show-toplevel
```

## Default Branch

Refresh refs and capture the repository snapshot:

```sh
git fetch --all --prune
git remote set-head origin -a 2>/dev/null || true
git branch --show-current
git status --porcelain=v1 -uall
git worktree list --porcelain
```

Prefer:

```sh
git symbolic-ref --quiet --short refs/remotes/origin/HEAD
```

Then fall back to `main`, `master`, or `trunk` only if the ref exists.

## Worktree Checks

Use the machine-readable worktree list captured in the repository snapshot.

Clean check including untracked files:

```sh
git -C <worktree-path> status --porcelain=v1 -uall
```

Merged check:

```sh
git merge-base --is-ancestor <branch> <default-ref>
```

Only if clean and merged:

```sh
git worktree remove <worktree-path>
```

## Branch Checks

List local branches:

```sh
git for-each-ref --format='%(refname:short)' refs/heads
```

Branch age:

```sh
git log -1 --format=%ct <branch>
```

Unique commits:

```sh
git rev-list --count <default-ref>..<branch>
```

Safe deletion:

```sh
git branch -d <branch>
```

Never use `git branch -D` in automation.

## Similar Work Check

If a stale branch has unique commits, compare patch IDs before deciding whether to tell the user it may duplicate another branch:

```sh
git show --patch --format= <branch> | git patch-id --stable
```

This is a weak heuristic. Similar work does not authorize deletion; it only improves the report.

## Disk Usage Checks

Find large repo areas:

```sh
du -sh .git .next/cache node_modules/.cache dist build target 2>/dev/null
```

Check whether generated directories are ignored:

```sh
git check-ignore -v .next/cache node_modules/.cache dist build target 2>/dev/null
```

Prune stale worktree metadata after safe deletions:

```sh
git worktree prune
```

When repository size or disk reduction is in scope, verify the repo is idle before running:

```sh
git gc
```

Safe Docker cleanup:

```sh
docker container prune -f --filter until=168h
docker image prune -f --filter until=168h
docker builder prune -f --filter until=168h
```

Avoid by default:

```sh
docker volume prune
rm -rf node_modules
git clean -fdx
```

## Remote Pattern

Use SSH aliases and the shared workspace:

```sh
ssh heztner-main 'find /home/workspace -name .git -type d ...'
```

Run destructive commands only after reporting the candidate and verifying it satisfies the safety rules.
