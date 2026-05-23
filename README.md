![Onmax Skills](https://raw.githubusercontent.com/onmax/skills/main/.github/onmax-skills-hero.png)

A growing collection of agent skills from my work on ViteHub, Nuxt, auth, validation, Nimiq, and AI coding tools.

```sh
npx skills add onmax/skills
```

## Included skills

| Skill | What it does |
| --- | --- |
| [`codex-session-finder`](skills/codex-session-finder/SKILL.md) | Finds local Codex sessions for review. |
| [`ecosystem-research`](skills/ecosystem-research/SKILL.md) | Checks how comparable systems solve a design problem. |
| [`fast-forward`](skills/fast-forward/SKILL.md) | Skips obvious branches during grilling sessions. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and captures project language. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`pr-refiner`](skills/pr-refiner/SKILL.md) | Reviews PR blockers and routes the next refinement step. |
| [`simplify`](skills/simplify/SKILL.md) | Finds the smallest useful simplification for a PR or scope. |
| [`setup-onmax-skills`](skills/setup-onmax-skills/SKILL.md) | Sets up lightweight repo-local guidance for Onmax skills. |
| [`skill-retrospective`](skills/skill-retrospective/SKILL.md) | Reviews Codex sessions and GitHub activity to improve skills. |
| [`strict-code-review`](skills/strict-code-review/SKILL.md) | Runs a strict maintainability review for structural quality and code-judo simplifications. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |

## Coordination patterns

- `grill-with-docs` can pause a design grilling loop and recommend `ecosystem-research` when external precedent would change an API, architecture, developer-experience, or platform decision.
- `grill-with-docs` should reconcile linked handoffs and parallel-session context before continuing with design questions.
- `simplify` routes high-impact simplifications through `validate-direction` before edits when the change affects public API, test policy, PR scope, domain language, or ADR-backed direction.
- `codex-session-finder` includes an active-worktree lookup recipe so PR and stack workflows can avoid mutating worktrees still owned by active Codex sessions.

## References

These skills build on patterns and ideas from:

- [fpgarciamtnz/World-of-Sofia](https://github.com/fpgarciamtnz/World-of-Sofia)
- [mattpocock/skills](https://github.com/mattpocock/skills)
