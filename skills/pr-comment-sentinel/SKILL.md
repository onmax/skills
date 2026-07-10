---
name: pr-comment-sentinel
description: Checks authored pull requests for current-head review evidence, green checks, unresolved feedback, and merge readiness. Use for a passive PR heartbeat, Codex quota fallback review, or explicitly allowed automatic merge.
---

# PR Comment Sentinel

The heartbeat is deterministic. AI is used only for an isolated, read-only fallback review when the external Codex reviewer is unavailable.

## Heartbeat

Run one pass and exit:

```sh
PR_COMMENT_SENTINEL_MERGE_REPOS=vite-hub/vitehub \
  scripts/run-heartbeat.sh gh:vite-hub/vitehub gh:quiverdk/portal
```

`run-heartbeat.sh` watches ViteHub and Portal by default and prints one JSON ledger row per authored open PR. The merge allowlist remains independent: Portal is report-only unless explicitly added. The timer supplies the next pass; do not poll inside a pass.

## Actions

| Action | Response |
| --- | --- |
| `fallback-review` | Reuse or start one detached read-only reviewer for the exact head. |
| `mark-ready` | Re-snapshot, then mark ready only if the action is unchanged. |
| `merge` | Re-snapshot, then squash-merge only if the action and head are unchanged. |
| `ready-for-human-review` | Report ready; perform no merge. |
| `wait-*`, `head-changed`, `ignore` | Report the blocker; perform no mutation. |

## Invariants

- `pr-readiness.sh` is the single readiness authority and uses every visible check.
- Quota replies make the Codex lane unavailable, not permanently pending.
- Fallback evidence must be observable, newer than the latest review command, and match the exact head.
- Failed workers cool down for 15 minutes before retrying, preventing two-minute failure storms.
- Workers never comment, edit, push, resolve threads, or merge. Only the heartbeat can perform the freshly gated merge action.
- Merge permission is repository-specific and every merge gets an immediate fresh snapshot plus `--match-head-commit`.
- Dirty source checkouts fail closed.

## Fallback Model

Fallback reviewers default to `gpt-5.6-sol` with `high` reasoning. Override with `PR_COMMENT_SENTINEL_MODEL` and `PR_COMMENT_SENTINEL_REASONING_EFFORT`.
