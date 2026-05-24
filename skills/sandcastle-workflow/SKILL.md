---
name: sandcastle-workflow
description: Executes confirmed ready-for-agent issues through Sandcastle or remote Codex until linked PRs are ready for a manual merge decision. Use when the user explicitly asks to run an issue through Sandcastle/VPS automation or process ready-for-agent issues.
---

# Sandcastle Workflow

## Quick Start

Use this for lifecycle stages 4-6:

```text
GitHub Issue -> autonomous implementation -> PR refinement -> pre-merge validation -> manual merge decision
```

Implementation, PR refinement, and merge-readiness validation are autonomous. Final merge remains manual.

## Workflow

1. Resolve the repository, issue number, output branch, target branch, and whether the run is local or VPS-backed.
2. Read the issue body and labels. Continue only if the issue has `ready-for-agent` and not `blocked` or `needs-info`.
3. If the user asks for "all ready-for-agent issues", "each issue", "one PR per issue", or similar batch execution, enter batch mode:
   - discover the open issues with `ready-for-agent` and without `blocked` or `needs-info`
   - process exactly one issue at a time
   - create or update exactly one branch and one PR per issue
   - allow stacked branches when the user requests or accepts stacking
   - keep final merge manual
   - return a PR matrix with issue, branch, base, PR URL, proof, status, and remaining blockers
4. Present an execution plan before mutation unless the user already gave an explicit execution command such as "run issue #123 and open a PR" or "open PRs for each ready-for-agent issue". Include label changes, branch name, target branch, local/VPS execution, expected proof, push behavior, PR creation, and whether branches may stack.
5. Move the issue from `ready-for-agent` to `in-agent-run`.
6. Use `sandcastle` for repository Sandcastle configuration, prompt shape, provider, and branch strategy.
7. Use `vps-connection` when executing remotely or when remote Codex helpers are involved. Follow its first-pass orientation, translate local paths to remote paths, verify Onmax skill availability, and state what remote state will change before remote branch creation, file writes, or agent execution.
8. Run one isolated autonomous agent task for the issue.
9. Run the issue's expected proof plus the smallest repo checks needed for confidence.
10. If implementation succeeds, open a PR using `pr-body`; include `Closes #<issue>` for automatic linking and leave the issue open until merge.
11. Run or route through `pr-refiner` autonomously for review-readiness, CI failures, conflicts, and scoped fixes.
12. Run or route through `pre-merge-validation` when the PR has consumer-facing package, runtime, provider, generated-output, docs-as-contract, or recent post-merge defect risk.
13. Remove `in-agent-run` only after implementation, PR refinement, and required merge-readiness validation are complete. The open linked issue intentionally has no workflow label until merge.
14. Stop before merge and return a concise readiness report for the human merge decision.
15. If blocked, apply `blocked` or `needs-info` with a concise reason in the final response. Do not post comments unless the user explicitly asks.

## Example

User: "Run issue #123 with Sandcastle and open a PR."

Expected flow: verify `ready-for-agent`, move to `in-agent-run`, run one isolated branch-based agent task, run the expected proof, open a PR with `Closes #123`, refine the PR, run required pre-merge validation, remove `in-agent-run`, and stop before merge.

User: "Process all ready-for-agent issues and open PRs. They may stack."

Expected flow: discover eligible issues, claim one issue, create a branch from the requested base or previous stack head, run one isolated task, open one PR, refine it, then continue with the next issue. End with a matrix of issue-to-PR results and no merges.

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
- Do not substitute planning or review for execution when the user explicitly asked to open PRs for issues.
- In batch mode, do not start a second issue until the current issue has a branch, PR, proof result, and clear status.
- If the generated PR exposes a consumer-facing package, runtime, provider, generated-output, docs-as-contract, or recent post-merge defect risk, expect `pre-merge-validation` later before merge.
