---
name: setup-onmax-skills
description: Sets up lightweight repo-local guidance, GitHub issue labels, and `.agents` project memory for Onmax skills. Use before first using Onmax skills in a repo, when `.agents` context is missing, when GitHub issue labels need the Onmax workflow vocabulary, or when agents need clearer instructions for project language, ADRs, simplification, validation, research, and handoff.
---

# Setup Onmax Skills

## Quick Start

Use this once per repo to give agents a small, consistent place to learn the project's language and how Onmax skills should compose.

It sets up project memory, skill usage guidance, and optionally the small GitHub issue label set used by Onmax agent workflows.

## Workflow

1. Inspect the repo for existing agent guidance:
   - `AGENTS.md`
   - `.agents/CONTEXT.md`
   - `.agents/CONTEXT-MAP.md`
   - `.agents/adr/`
   - legacy `CONTEXT.md`, `CONTEXT-MAP.md`, or `docs/adr/`
2. Summarize what exists and what is missing.
3. Create `AGENTS.md` if it does not exist.
4. Add or update one `## Agent skills` block in `AGENTS.md`.
5. Create `.agents/` lazily only for useful project memory.
6. If the repo uses GitHub Issues, offer to set up the Onmax workflow labels.

## Agent Skills Block

Use this shape:

```md
## Agent skills

This repo uses Onmax skills for project language, simplification, research, validation, and handoff.

- Use `grill-with-docs` to clarify project language and record decisions.
- Use `simplify` to review PR diffs or explicit scopes for accidental complexity.
- Use `strict-code-review` for strict maintainability reviews and ambitious structural cleanup.
- Use `validate-direction` before turning a direction into a plan, ADR, or implementation.
- Use `evidence-research` when internal or external evidence would change the decision.
- Use `handoff` to preserve continuation context for another agent or session.
- Use `fast-forward` inside grilling sessions to skip low-value branches.
- Use `codex-skill-retrospective` to analyze recent Codex sessions and GitHub activity for skill improvements.

Project memory lives under `.agents/`:

- `.agents/CONTEXT.md` for project vocabulary in a single-context repo.
- `.agents/CONTEXT-MAP.md` plus `.agents/contexts/<name>/CONTEXT.md` for multi-context repos.
- `.agents/adr/` for decisions worth preserving.
```

If an `## Agent skills` block already exists, update it in place. Do not duplicate the section.

## Project Memory

Create files only when there is real content to write.

- Create `.agents/CONTEXT.md` when a project-specific term is resolved.
- Create `.agents/CONTEXT-MAP.md` only when the repo has multiple meaningful contexts.
- Create `.agents/adr/` only when a hard-to-reverse, surprising, trade-off-backed decision is accepted.

Legacy root `CONTEXT.md`, root `CONTEXT-MAP.md`, and `docs/adr/` may be read as fallback context, but new Onmax project memory should go under `.agents/` unless the user asks otherwise.

## GitHub Labels

Offer to create or update this minimal first-iteration label set when the repository uses GitHub Issues:

| Label | Color | Description |
| --- | --- | --- |
| `needs-info` | `F8D7DA` | Missing information before an agent or maintainer can proceed. |
| `ready-for-agent` | `D8F3DC` | Issue has enough context and acceptance criteria for an autonomous agent run. |
| `in-agent-run` | `DDEBFF` | An autonomous agent or Sandcastle run is actively working on this issue. |
| `blocked` | `FFE5B4` | Work cannot continue without a human decision, external access, or dependency. |

Use pastel colors and concise descriptions. Keep the set small until the workflow proves it needs more labels.

Before mutating GitHub labels, show the exact create/update/delete plan and ask for explicit approval. Do not post comments, create issues, or change unrelated GitHub state.

If GitHub's default labels create noise, offer to remove them only when they are unused on open issues and pull requests. Check usage first. Never delete a label that is currently applied unless the user explicitly approves that specific deletion after seeing the affected issue or PR count.

## Done

Report what changed and which file agents should read first.
