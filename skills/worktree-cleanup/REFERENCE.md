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
  \( -name node_modules -o -name .next -o -name dist -o -name build -o -name target -o -name .git \) -prune \
  -o -name .git -type d -print
```

For each `.git`, resolve the top-level repo:

```sh
git -C <candidate> rev-parse --show-toplevel
```

## Default Branch
Prefer:

```sh
git symbolic-ref --quiet --short refs/remotes/origin/HEAD
```

Then fall back to `main`, `master`, or `trunk` only if the ref exists.

## Worktree Checks
Machine-readable worktree list:

```sh
git worktree list --porcelain
```

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

Prefer Git cleanup before deleting build artifacts:

```sh
git worktree prune
git gc --prune=now
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
