# Agent Instructions

Code comments: only when necessary; explain *why*, not *what*. If code is self-explanatory, skip comments.

Prefer the browser skill over agent browser, Chromium, or Playwright when browser inspection is needed.

Never comment on issues or pull requests without explicit user consent.

Activate the GitHub, Vercel, or Cloudflare plugin when relevant.

## Agent skills

This repo uses Onmax skills for project language, simplification, research, validation, and handoff.

- Use `grill-with-docs` to clarify project language and record decisions.
- Use `simplify` to review PR diffs or explicit scopes for accidental complexity.
- Use `strict-code-review` for strict maintainability reviews and ambitious structural cleanup.
- Use `validate-direction` before turning a direction into a plan, ADR, or implementation.
- Use `ecosystem-research` when external precedent would change the decision.
- Use `handoff` to preserve continuation context for another agent or session.
- Use `fast-forward` inside grilling sessions to skip low-value branches.
- Use `codex-skill-retrospective` to analyze recent Codex sessions and GitHub activity for skill improvements.

Project memory lives under `.agents/`:

- `.agents/CONTEXT.md` for project vocabulary in a single-context repo.
- `.agents/CONTEXT-MAP.md` plus `.agents/contexts/<name>/CONTEXT.md` for multi-context repos.
- `.agents/adr/` for decisions worth preserving.

Read `.agents/CONTEXT.md` first for this repo's current language around merge readiness and consumer-install validation.
