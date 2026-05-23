---
name: design-to-agent-work
description: Orchestrates fuzzy direction into validated memory and an issue-shaping handoff for agent work. Use when the user wants to design work for agents, turn a conversation into executable issues, or run the human-guided stages before Sandcastle/VPS execution.
---

# Design To Agent Work

## Quick Start

Use this as the parent workflow for stages 1-3 of the Onmax agent lifecycle:

```text
Clarify Direction + Capture Durable Memory -> Shape Agent Work
```

Default output target is GitHub Issues. Other targets may be supported later, but name the target explicitly so the lifecycle does not depend on GitHub-specific wording.

## Workflow

1. Establish the topic, repository, output target, and whether this is new work or continuation from a handoff, issue, PRD, ADR, or Codex session.
2. Clarify direction using the smallest useful mix of existing skills:
   - `grill-with-docs` for project language, boundaries, and ADR-worthy trade-offs.
   - `evidence-research` for internal or external evidence.
   - `codex-session-finder` for prior session evidence.
   - `codex-skill-retrospective` for repeated agent-pattern evidence.
   - `simplify` or `strict-code-review` when the concern is accidental complexity.
   - `handoff` when continuation context must be preserved.
3. Capture durable memory only when it belongs there:
   - `.agents/CONTEXT.md` is vocabulary only.
   - ADRs are atomic, hard-to-reverse decisions with real trade-offs.
   - PRDs are optional broader product/work intent artifacts.
4. Use `validate-direction` whenever a direction is about to harden into durable memory, issue breakdown, workflow rule, or execution contract.
5. Invite or run `shape-agent-work` once the direction is clear enough to create agent-ready issues.
6. End by listing created/updated artifacts and the recommended next action, usually running `sandcastle-workflow` manually on the created issues.

## Example

User: "Use design-to-agent-work for the workspace source redesign."

Expected flow: clarify terms with `grill-with-docs`, validate the direction before it hardens, write any atomic ADRs or glossary terms, then hand the resolved direction to `shape-agent-work` for GitHub issues.

## Rules

- This skill coordinates; it does not implement source changes.
- Do not put implementation details in `.agents/CONTEXT.md`.
- Prefer issues and PR bodies for detailed execution context that should not pollute repo memory.
- GitHub issue creation, updates, and labels are allowed for the scoped work once the user has invoked this workflow. Do not mutate unrelated issues or PRs.
- Never post PR comments, close issues, merge PRs, or force-push without explicit consent.

## Lifecycle

```text
clarify/design -> ready-for-agent -> in-agent-run -> PR opened
                                      |
                                      v
                                blocked / needs-info
```

After PR creation, remove `in-agent-run` and leave the issue open without a workflow label until the linked PR merges.
