---
name: setup-onmax-skills
description: Sets up lightweight repo-local guidance for Onmax skills and `.agents` project memory. Use before first using Onmax skills in a repo, when `.agents` context is missing, or when agents need clearer instructions for project language, ADRs, simplification, validation, research, and handoff.
---

# Setup Onmax Skills

## Quick Start

Use this once per repo to give agents a small, consistent place to learn the project's language and how Onmax skills should compose.

It only sets up project memory and skill usage guidance.

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

## Agent Skills Block

Use this shape:

```md
## Agent skills

This repo uses Onmax skills for project language, simplification, research, validation, and handoff.

- Use `grill-with-docs` to clarify project language and record decisions.
- Use `simplify` to review PR diffs or explicit scopes for accidental complexity.
- Use `strict-code-review` for strict maintainability reviews and ambitious structural cleanup.
- Use `validate-direction` before turning a direction into a plan, ADR, or implementation.
- Use `ecosystem-research` when external precedent would change the decision.
- Use `handoff` to preserve continuation context for another agent or session.
- Use `fast-forward` inside grilling sessions to skip low-value branches.

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

## Done

Report what changed and which file agents should read first.
