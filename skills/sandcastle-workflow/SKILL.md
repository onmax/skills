---
name: sandcastle-workflow
description: Executes confirmed ready-for-agent issues through Sandcastle or remote Codex and opens linked pull requests. Use when the user explicitly asks to run an issue through Sandcastle/VPS automation or process ready-for-agent issues.
---

# Sandcastle Workflow

## Quick Start

Use this for lifecycle stages 4-5:

```text
GitHub Issue -> Sandcastle/VPS autonomous implementation -> PR opened
```

Final merge remains manual.

## Workflow

1. Resolve the repository, issue number, output branch, target branch, and whether the run is local or VPS-backed.
2. Read the issue body and labels. Continue only if the issue has `ready-for-agent` and not `blocked` or `needs-info`.
3. Present an execution plan before mutation unless the user already gave an explicit execution command such as "run issue #123 and open a PR". Include label changes, branch name, target branch, local/VPS execution, expected proof, push behavior, and PR creation.
4. Move the issue from `ready-for-agent` to `in-agent-run`.
5. Use `sandcastle` for repository Sandcastle configuration, prompt shape, provider, and branch strategy.
6. Use `vps-connection` when executing remotely or when remote Codex helpers are involved. Follow its first-pass orientation and state what remote state will change before remote branch creation, file writes, or agent execution.
7. Run one isolated autonomous agent task for the issue.
8. Run the issue's expected proof plus the smallest repo checks needed for confidence.
9. If successful, open a PR using `pr-body`; include `Closes #<issue>` for automatic linking and leave the issue open until merge.
10. Remove `in-agent-run` after the PR is opened. The open linked issue intentionally has no workflow label until merge.
11. Recommend `pr-refiner` for review-readiness, CI failures, conflicts, or scoped fixes.
12. If blocked, apply `blocked` or `needs-info` with a concise reason in the final response. Do not post comments unless the user explicitly asks.

## Example

User: "Run issue #123 with Sandcastle and open a PR."

Expected flow: verify `ready-for-agent`, move to `in-agent-run`, run one isolated branch-based agent task, run the expected proof, open a PR with `Closes #123`, remove `in-agent-run`, and stop before merge.

## Labels

V1 issue labels:

```text
needs-info
ready-for-agent
in-agent-run
blocked
```

Do not add new workflow labels in v1 unless the user asks.

## Rules

- Do not start from vague issues. Route to `shape-agent-work` first.
- Do not merge PRs.
- Do not close issues manually on success; GitHub closes them when the linked PR merges.
- Never post issue or PR comments without explicit consent.
- Do not mutate active or uncertain Codex worktrees.
- If the generated PR exposes a consumer-facing package, runtime, provider, generated-output, docs-as-contract, or recent post-merge defect risk, expect `pre-merge-validation` later before merge.
