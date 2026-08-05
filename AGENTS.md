# Agent Instructions

Code comments: only when necessary; explain *why*, not *what*. If code is self-explanatory, skip comments.

Prefer the browser skill over agent browser, Chromium, or Playwright when browser inspection is needed.

Never comment on issues or pull requests without explicit user consent.

Activate the GitHub, Vercel, or Cloudflare plugin when relevant.

## Repository workflow

Work directly on `main` for this repo unless the user explicitly asks otherwise.

Do not create branches or worktrees for normal changes in this repo. This repository is the source used to sync local skills into `~/.agents/skills`, so branch/worktree copies can leave stale skill symlinks behind.

## Agent skills

This repo uses Onmax skills for project language, review, research, validation, and handoff.

- Use `grill-with-docs` when the user asks for a decision interview; create project documentation only when they also request the artifact.
- Use `code-review` for diff review, including strict maintainability review.
- Use `pull-request` for contribution fit, PR feedback, CI, conflicts, and merge readiness.
- Use `validate-direction` before turning a direction into a plan, ADR, or implementation.
- Use `evidence-research` when internal or external evidence would change the decision.
- Use `handoff` to preserve continuation context for another agent or session.

Create glossaries, context maps, or ADRs only when the user explicitly requests them.
