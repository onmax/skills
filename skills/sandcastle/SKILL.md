---
name: sandcastle
description: Explains Sandcastle configuration, providers, prompts, branch strategies, and completion signals. Use when setting up Sandcastle or choosing one isolated agent-run harness.
---

# Sandcastle

## Quick Start

Sandcastle orchestrates coding agents in isolated sandboxes from TypeScript. Use it as an execution engine, not as the work-shaping layer.

Core concepts live in [REFERENCE.md](REFERENCE.md).

## Workflow

1. Inspect whether the repo already has `.sandcastle/` configuration.
2. If not configured, recommend `sandcastle init` and choose the smallest local provider first, usually Docker or Podman.
3. Prefer prompt files for reusable workflows because they support prompt arguments.
4. Use explicit branch strategies for issue-driven work so each run produces reviewable commits.
5. Keep Sandcastle prompts focused on one issue contract at a time unless the user explicitly asks for parallel batches.
6. Do not merge final PRs from this skill.

## Example

User: "Set up Sandcastle for issue-driven agent runs."

Expected output: recommend a provider, prompt file, branch strategy, completion signal, and whether the run should be local or use `vps-connection`. Do not start the workflow unless the user asks to execute it.

## Branch Strategy Guidance

- `head`: direct host working directory writes. Avoid for autonomous issue execution unless the user explicitly wants it.
- `merge-to-head`: temporary branch merged back to current HEAD. Useful for local experiments.
- `branch`: commits land on an explicit branch. Prefer for GitHub issue automation and PR creation.

## Rules

- Do not let Sandcastle invent the task contract; use `shape-agent-work` first.
- Keep each run isolated and reviewable.
- Prefer manual trigger for v1. Webhooks can come later after the workflow is trusted.
- Use `vps-connection` when the run happens on the VPS or through remote Codex helpers.
- Use `pr-body` when opening PRs from Sandcastle output.
- Never read or print Sandcastle `.env`, `codex-home/`, auth files, Codex config, or provider tokens.

## Reference

Use [REFERENCE.md](REFERENCE.md) for Sandcastle concepts and command/API examples.
