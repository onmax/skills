# Agent Instructions

Code comments: only when necessary; explain *why*, not *what*. If code is self-explanatory, skip comments.

Prefer the browser skill over agent browser, Chromium, or Playwright when browser inspection is needed.

Never comment on issues or pull requests without explicit user consent.

Activate the GitHub, Vercel, or Cloudflare plugin when relevant.

## Repository workflow

Work directly on `main` for this repo unless the user explicitly asks otherwise.

Do not create branches or worktrees for normal changes in this repo. This repository is the source used to sync local skills into `~/.agents/skills`, so branch/worktree copies can leave stale skill symlinks behind.

## Agent skills

This repo uses Onmax skills for project language, simplification, research, validation, and handoff.

- Use `grill-with-docs` only when the user explicitly asks to capture a grilling result in project documentation.
- Use `simplify` to review PR diffs or explicit scopes for accidental complexity.
- Use `strict-code-review` for strict maintainability reviews and ambitious structural cleanup.
- Use `validate-direction` before turning a direction into a plan, ADR, or implementation.
- Use `evidence-research` when internal or external evidence would change the decision.
- Use `handoff` to preserve continuation context for another agent or session.
- Use `fast-forward` inside grilling sessions to skip low-value branches.

Create glossaries, context maps, or ADRs only when the user explicitly requests them.
