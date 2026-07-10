---
name: pr-comment-sentinel
description: Reconciles authored pull-request feedback and current-head readiness. Use for a passive PR heartbeat, automated Codex feedback repair, fallback review, or repository-specific ready/merge coordination.
---

# PR Comment Sentinel

The sentinel is a bounded coordinator. Scripts own observable GitHub state; agents own feedback judgment, code changes, and fallback code review.

## Heartbeat

1. Run `scripts/heartbeat-state.sh` for every watched repository. The step is complete when every open authored PR appears once with an exact head and action.
2. Execute only the named action. Load [WORKERS.md](WORKERS.md) when the action needs an owner. Start every independent owner before revisiting running lanes.
3. Obtain a fresh `scripts/pr-readiness.sh` snapshot immediately before `@codex review`, `gh pr ready`, or merge. Head drift or a different action cancels the mutation.
4. Report one ledger row per snapshot: repository, PR, head, action, owner evidence, result, and blocker. Exit after one pass; the timer supplies the next pass.

The readiness snapshot is the single source of truth. It keeps external Codex lane state separate from accepted review evidence, treats a quota response as unavailable rather than pending, validates fallback freshness, uses all visible checks, and fails closed on missing or unknown evidence.

## Actions

| Action | Coordinator response |
| --- | --- |
| `fix-feedback` | Start one implementation owner for the unresolved current threads. |
| `refresh-branch` | Start one owner to update the branch without force-pushing. |
| `repair-checks` | Start one owner from the failed check logs and narrow repro. |
| `fallback-review` | Start one separate read-only review owner immediately. |
| `fix-fallback` | Start one implementation owner from the fallback finding. |
| `request-review` | Post exactly `@codex review` only when the snapshot says comments are allowed. |
| `mark-ready` | Re-snapshot, run `gh pr ready`, then stop until the next heartbeat. |
| `merge` | Re-snapshot, then squash-merge with the PR title as the subject and an empty body. |
| `ready-for-human-review` | Report ready; perform no merge. |
| `wait-*`, `head-changed`, `ignore` | Report the exact blocker; perform no mutation. |

## Mutation Boundary

- Comment permission defaults to disabled. The exact review nudge is the only comment this skill can authorize.
- Merge permission is explicit repository policy. No repository inherits it from another.
- Workers post no comments and perform no merge.
- A pushed commit invalidates earlier review evidence; the next heartbeat reviews the new head.
- Preserve dirty or unique worktrees. Use `worktree-cleanup` for cleanup after worker evidence is consumed.

## Commands

```sh
scripts/heartbeat-state.sh gh:vite-hub/vitehub
scripts/pr-readiness.sh --expected-head <sha> --fallback <review.json> --merge allowed --comments disabled vite-hub/vitehub <pr>
scripts/summonize-pr-comments.sh gh:vite-hub/vitehub
```
