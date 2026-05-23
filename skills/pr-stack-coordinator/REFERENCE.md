# PR Stack Coordinator Reference

## Dependency Marker Examples

Hard dependency:

```md
## Merge Dependencies

- Blocks merge until: #150
- Reason: this branch is stacked on `codex/workspace-api-cleanup`.
```

Coordination note:

```md
## Merge Coordination

- Coordinates with: #152, #155
- Reason: these PRs touch the same root export line; keep all exported symbols when rebasing.
```

Preserve existing repository wording when it is already clear.

## Merge Confirmation Example

```md
Ready to squash merge #152.

Final commit:
feat(agent): add transcription capability

Adds audio message parts, chat attachment handoff, and the `transcribe()`
input phase capability.

PR: #152

Confirm: squash merge PR #152 into main?
```

## CLI Examples

Use `gh` and `git` for deterministic state:

```sh
git worktree list --porcelain
git status --short --branch
git branch --show-current
git merge-base --is-ancestor <possible-base> <head>
git diff --name-only <base>...<head>
gh pr list --state open --json number,title,baseRefName,headRefName,isDraft,mergeStateStatus,reviewDecision,url
gh pr view <pr> --json number,title,body,baseRefName,headRefName,isDraft,mergeStateStatus,reviewDecision,statusCheckRollup,files,commits,url
```
