---
name: workflow
description: Orchestrates a bounded autonomous work loop with heartbeats, child or project threads, delegated agents, review gates, and PR readiness coordination. Use when the user asks for a workflow, autonomous run, long-running agent loop, heartbeat cadence, child-thread delegation, multi-agent coordination, review loop, session splitting, stale PR reconciliation, or human-at-start-and-end execution.
---

# Workflow

Use this to make the current thread the coordinator for an adaptive workflow. Default to split-and-coordinate, but reconcile before spawning. Keep the human out of routine steering, not out of authority decisions.

## Start Contract

Establish the smallest contract that can carry the work:

- objective, scope, out-of-scope work, final decision, and stop conditions
- autonomy window and heartbeat cadence, if thread wakeups exist
- allowed mutations: files, branches, PRs, commands, network, and external systems
- forbidden actions and approval gates
- delegation rules, target projects, and whether children may spawn descendants
- evidence required before completion

Infer harmless details. Ask only when missing authority, safety, or objective details would change the workflow.

## Reconcile And Ledger

Before creating work, inspect available thread, worktree, branch, PR, CI, and review state. Find existing sessions on the same goal, more advanced branches or PRs, stale or superseded PRs, bot review signals, and files/branches/PRs already claimed by another active session.

Prefer updating the most advanced valid branch over duplicating work. If a PR looks stale or superseded, record evidence and a recommended action; do not close, label, comment, or merge unless the user granted that authority.

Keep a compact ledger in the thread or a temporary artifact:

```text
objective:
checkpoint:
next heartbeat:
existing work:
active children:
claimed areas:
prs and reviews:
checks and artifacts:
blockers:
approval gates:
verification:
residual risk:
stop condition:
```

Update it after each heartbeat, child result, review pass, or material state change.

## Loop

1. Reconcile existing work, then build the smallest task graph that can reach the final decision.
2. For non-trivial workflows, spawn child or project threads by default. Keep only trivial one-step work inline.
3. Give each child one owned slice, inherited guardrails, expected output, completion criterion, target branch or PR, and descendant-spawn permission.
4. Avoid collisions: no two active children own the same files, branch, PR, deploy, or external side effect unless the conflict is explicit and coordinated.
5. On each heartbeat, read new user messages first, then check child states, PR/review state, CI/status checks, logs, command output, and artifacts.
6. Reconcile conflicts, update the ledger, then continue, revise delegation, cancel stale work, or stop.
7. Run review loops only against concrete criteria. Repair with the smallest check that can prove the fix.
8. Parent-gate delegated work: verify each child report, changed files, branch/head, and at least one integrated check before treating it as complete.
9. Finish when every child has a terminal state and the final decision package is ready.

If the environment has no heartbeat or child-thread tool, run the same loop inline and report the missing capability as a limitation.

## PR Readiness

When a workflow creates or touches PRs, coordinate readiness without becoming the PR worker:

- Use `pr-refiner` for one-PR refinement, review-comment handling, CI, branch freshness, mergeability, and current-head checks.
- Use `pr-body` when opening, updating, or checking PR body text, issue links, dependency notes, or coordination notes.
- Treat bot comments, Codex thumbs-up, and AI review output as readiness evidence, not human approval.
- Track which head SHA each check, preview, browser proof, or bot review applies to.
- Batch fixes to avoid noisy pushes and reviewer notifications.
- For multiple PRs or stacks, keep dependency and stale/superseded status in the ledger and route single-PR execution to the right child thread.

## Guardrails

- Never merge to `main`, a release branch, or a protected branch unless the user explicitly said to merge.
- Do not post issue or PR comments, approve/request changes, label, close, force-push, deploy, release, mutate infrastructure, touch production data, expose secrets, or expand access unless the start contract explicitly permits that action.
- Do not let child agents or descendants exceed the parent contract.
- Do not hide approval-sensitive work inside a child thread.
- Treat automated review as evidence, not human approval.
- Stop scheduling heartbeats when the workflow is complete, blocked on approval, or no longer gaining signal.

If progress needs a forbidden action, record it as an approval gate for the final decision package instead of taking it.

## Output

End with workflow status, evidence, child states, PRs and reviews, verification passed/failed/skipped/residual risk, approval gates, and the recommended final decision.
