---
name: shape-agent-work
description: Converts clarified direction, ADRs, PRDs, handoffs, or conversation context into executable GitHub issues. Use when resolved work should be split into ready-for-agent issues for autonomous implementation.
---

# Shape Agent Work

## Quick Start

Use this after a direction is clear enough to delegate but before autonomous agents start coding.

Default target: GitHub Issues.

V1 labels:

```text
needs-info
ready-for-agent
in-agent-run
blocked
```

## Workflow

1. Gather context from the conversation, ADRs, PRDs, handoffs, existing issues, and project memory.
2. Inspect the codebase enough to remove implementation ambiguity, using project vocabulary and respecting ADRs.
3. If the source direction has not already been validated and the issue contract would harden a workflow, API, architecture, or broad implementation direction, run `validate-direction`.
4. Break the work into vertical slices that can be completed independently by an agent.
5. For each slice, decide whether it is executable now:
   - `ready-for-agent`: enough context, scope, acceptance criteria, and proof expectations.
   - `needs-info`: a missing answer would change the work.
   - `blocked`: intent is clear, but execution depends on an external blocker.
6. Create or update GitHub issues in dependency order.
7. Apply exactly one workflow label from the V1 label set. A linked issue may intentionally have no workflow label after a PR is opened.
8. Return the issue list, dependencies, and the suggested `sandcastle-workflow` invocation.

## Issue Body

Use this shape unless the target repo has a stronger issue template:

```md
## What to build

Describe the end-to-end behavior this issue should deliver.

## Context

Link relevant ADRs, PRDs, prior issues, handoffs, PRs, or docs. Keep implementation details here, not in `.agents/CONTEXT.md`.

## Acceptance criteria

- [ ] Specific, testable criterion
- [ ] Specific, testable criterion

## Expected proof

State the cheapest credible proof: test, typecheck, build, browser check, consumer repro, or other command.

## Out of scope

- Adjacent work the agent should not do
```

## Example

User: "Turn the accepted ADR into issues for Sandcastle."

Expected output: one or more GitHub issues labeled `ready-for-agent`, each with a behavior-focused `What to build`, links to the ADR or PRD, acceptance criteria, expected proof, and out-of-scope notes.

## Rules

- Prefer many small vertical slices over broad horizontal tickets.
- Describe behavior and contracts more than file-by-file procedure.
- Include file paths only when they are stable enough to help; avoid line numbers.
- Mark an issue `ready-for-agent` only when an autonomous agent can begin without asking a design question.
- Do not close parent/source issues.
- Do not post PR comments or mutate PR state.
