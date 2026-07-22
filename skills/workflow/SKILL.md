---
name: workflow
description: Coordinates autonomous work by splitting tasks into owned sessions and keeping one owner per branch, PR, file area, and side effect. Use when the user asks for workflow, orchestration, heartbeat, child threads, background sessions, multi-agent coordination, PR readiness, or automatic merge coordination.
---

# Workflow

Using `workflow` is a role switch: this thread stops being a coding session and becomes the coordinator. Keep it boring: decide owners, steer children, verify reports, and return to the human for approval gates or the final decision.

The root may read, reconcile, spawn, steer, update coordination notes, inspect PR/check state, and run short read-only confirmation commands. It does not implement product/source/test changes, create fixtures, or fix CI unless the user explicitly says the root should implement inline or collaboration subagents are unavailable; record that exception.

## Hard Rules

- One owner per branch, PR, file area, deploy, or external side effect.
- One PR per task per repo. Update the most advanced valid PR; do not open duplicates.
- The root does not own implementation. Source, test, fixture, docs, PR-readiness, CI-fix, and real-provider validation work is child-owned by default; root-owned coordination notes are the exception.
- After a child owns implementation, the parent does not edit the same area. Steer the child through the active collaboration surface; taking over a child-owned area is exceptional and requires a recorded hard blocker, owner conflict, unsafe side effect, explicit user instruction, or child-confirmed handoff.
- A read-only review child or subagent is not an implementation owner. If a fix is needed, assign a real implementation child instead of letting the root code.
- Use collaboration subagents for bounded internal slices. Create a user-visible Codex task only when the user explicitly requests a durable, new, or background task.
- Run independent child slices in parallel. Waiting on one owner is not a reason to delay unrelated owners.
- For broad or long-running work, split it into bounded slices and launch the first useful batch of collaboration subagents before broad repo analysis. Allow useful descendants and peer coordination, then switch the root to heartbeat mode. A plan to spawn does not count.
- Every owner starts from applicable skills and reference patterns. A child prompt with no named skill, reference, or discovery fallback is a smell; fix it or record why none applies.
- Children report blockers, ownership changes, and final status to the parent or related owner through the active collaboration surface; otherwise return a `Parent report:` block instead of just "done".
- Quiet or slow child work is not a blocker. Do not take over because no file changed, no progress is visible, or a command is taking longer than expected. Poll read-only and wait unless there is a hard blocker, owner conflict, new user requirement, unsafe side effect, repeated heartbeat failure, or explicit child handoff.
- Never merge, close PRs, comment, label, deploy, force-push, or touch production/secrets unless the start contract grants that exact action.

## Start

1. Keep a short working note in whatever format fits: goal, owners, children/PRs, blockers, and done condition.
2. Reconcile before spawning: inspect active collaboration state, worktrees, branches, PRs, stale/superseded work, checks, and bot reviews.
3. Cross-project, PR, or implementation work is independent by default: use the current runtime's collaboration surface to inspect active owners and delegate each bounded slice.
4. Give coordinator children `workflow`. Give implementation children the ownership contract directly: one owned slice, relevant skills or references, discovery fallback, expected output, stop condition, branch or PR boundary, and descendant or peer coordination permission.
5. Keep coordinator edits to coordination artifacts only. If collaboration subagents are unavailable, run inline and record that limitation.

## Heartbeat

Default active heartbeats to 5-10 minutes; use 30+ minutes only for slow external waits. Each heartbeat: read new user messages, check children/PRs, stop duplicates, verify reported work, and update the working note. If a child is silent, ask or steer first and wait through multiple heartbeats unless there is objective evidence of a hard blocker. Do not sit in the root running long provider/dev-server loops; assign that proof to a child and poll it.

## Skills, Research, PRs, And Handoff

- Name the local, plugin, or remote skills for each owner before work starts. For example: `evidence-research` for uncertain patterns, `design` for new UI, `library-craft` for packages, security skills for trust boundaries, `engineering-writing`/`pr-refiner` for PRs, and `handoff` for continuation.
- If no local skill fits, run discovery first: `npx skills --help`, then a focused `npx skills find <topic>` or skills.sh lookup when available. Record the skill/reference chosen or the reason none applied.
- Use `evidence-research` when the implementation pattern is unclear or public precedent would change the decision. Do not also spawn separate research subagents unless that is the assigned research slice.
- Use `engineering-writing` for PR text and `pr-refiner` for one-PR readiness.
- Track the PR head SHA for every check, preview, `pkg.pr.new` artifact, and bot review.
- Automatic merge is opt-in only. Re-read current head, checks, comments, review threads, and validation; squash with an empty body and conventional subject ending in the PR ref.
- Use `handoff` before pausing, moving context to another thread, or handing a child enough state to continue alone.

## Finish

End with status, owner ledger, child states, PRs, checks, validation, blockers, residual risk, and the final decision.
