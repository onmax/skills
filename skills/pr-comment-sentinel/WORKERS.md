# Sentinel Workers

Load this reference only when a readiness snapshot names a worker action.

## Ownership

One PR head has one observable owner. Reuse a live owner for the same head; a PID is live only when `kill -0` succeeds. Every worker prompt names the repository, PR, authorized head, worktree, allowed mutations, status path, and completion criterion.

Create worktrees under:

```text
<workspace>/pr-comment-sentinel/<owner-repo>/pr-<number>-<head>
```

Launch a detached Codex worker when no durable child-task API is available:

```sh
setsid /bin/bash -lc 'exec codex exec --dangerously-bypass-approvals-and-sandbox -C "<worktree>" - < "<prompt>" > "<log>" 2>&1' </dev/null &
echo $! > "<pid>"
kill -0 "$(cat "<pid>")"
```

Leave prompt, log, PID, and status evidence for the next heartbeat. Cleanup happens only after the result is consumed and the worktree is clean.

## Feedback, Branch, And Check Workers

Actions `fix-feedback`, `refresh-branch`, `repair-checks`, and `fix-fallback` use an implementation owner. The prompt requires `workflow` and `pr-refiner`, scopes the owner to one PR/head, and permits the smallest branch push needed to complete that lane.

Completion is one atomic JSON file at `.pr-comment-sentinel-worker.json`:

```json
{"schema":1,"status":"pushed","authorizedHead":"<sha>","head":"<new-sha>","commit":"<sha>","completedAt":"<iso-time>","checks":["<command>"],"resolvedThreads":["<id>"],"reason":"<short reason>"}
```

Blocked work uses `"status":"blocked"` and an exact `reason`. The owner posts no comments and performs no merge. It resolves a thread only after the pushed change addresses it.

## Fallback Review Worker

Action `fallback-review` uses a separate read-only owner. The prompt requires review of the exact base-to-head diff for correctness, regressions, security, missing tests, and mismatch with PR intent. It permits no edits, comments, pushes, thread resolution, or merge.

Completion is one atomic JSON file at `.pr-comment-sentinel-review.json`:

```json
{"schema":1,"verdict":"no-major-issues","head":"<sha>","reviewedAt":"<iso-time>","reason":"<short reason>"}
```

Allowed verdicts are `no-major-issues`, `needs-fix`, and `inconclusive`. Write to a temporary sibling and rename it into place so the readiness snapshot never reads a partial verdict.

The fallback is evidence, not permission. Only `pr-readiness.sh` decides whether it is fresh and admissible.
