![Onmax Skills](https://raw.githubusercontent.com/onmax/skills/main/.github/onmax-skills-hero.png)

A growing collection of agent skills from my work on ViteHub, Nuxt, auth, validation, Nimiq, and AI coding tools.

```sh
npx skills add onmax/skills
```

## Included skills

| Skill | What it does |
| --- | --- |
| [`better-icons`](skills/better-icons/SKILL.md) | Finds and retrieves icons from Iconify libraries. |
| [`caveman`](skills/caveman/SKILL.md) | Switches to ultra-compressed communication. |
| [`codex-session-finder`](skills/codex-session-finder/SKILL.md) | Finds local Codex sessions for review. |
| [`descartes-skill`](skills/descartes-skill/SKILL.md) | Separates facts, constraints, assumptions, and evidence. |
| [`diagnose`](skills/diagnose/SKILL.md) | Runs disciplined diagnosis for hard bugs and regressions. |
| [`diff`](skills/diff/SKILL.md) | Opens branch or PR diffs in Zed. |
| [`document-writer`](skills/document-writer/SKILL.md) | Guides blog post and documentation writing. |
| [`ecosystem-research`](skills/ecosystem-research/SKILL.md) | Checks how comparable systems solve a design problem. |
| [`fast-forward`](skills/fast-forward/SKILL.md) | Skips obvious branches during grilling sessions. |
| [`frontend-design`](skills/frontend-design/SKILL.md) | Guides production-grade frontend interface design. |
| [`grill-me`](skills/grill-me/SKILL.md) | Interrogates a plan one decision at a time. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and captures project language. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | Finds codebase architecture deepening opportunities. |
| [`karpathy-guidelines`](skills/karpathy-guidelines/SKILL.md) | Applies behavioral guidelines for more reliable coding. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`my-skill`](skills/my-skill/SKILL.md) | Test skill. |
| [`pr-refiner`](skills/pr-refiner/SKILL.md) | Reviews PR blockers and routes the next refinement step. |
| [`pr-stack-coordinator`](skills/pr-stack-coordinator/SKILL.md) | Coordinates stacked PRs, worktrees, ADR indexes, and merges. |
| [`prototype`](skills/prototype/SKILL.md) | Builds throwaway prototypes to explore a direction. |
| [`simplify`](skills/simplify/SKILL.md) | Finds the smallest useful simplification for a PR or scope. |
| [`setup-onmax-skills`](skills/setup-onmax-skills/SKILL.md) | Sets up lightweight repo-local guidance for Onmax skills. |
| [`skill-retrospective`](skills/skill-retrospective/SKILL.md) | Reviews Codex sessions and GitHub activity to improve skills. |
| [`strict-code-review`](skills/strict-code-review/SKILL.md) | Runs a strict maintainability review for structural quality and code-judo simplifications. |
| [`tdd`](skills/tdd/SKILL.md) | Guides test-driven development. |
| [`to-issues`](skills/to-issues/SKILL.md) | Breaks a plan into tracker-ready issues. |
| [`to-prd`](skills/to-prd/SKILL.md) | Turns conversation context into a PRD. |
| [`triage`](skills/triage/SKILL.md) | Triage issues through a role-driven state machine. |
| [`ui`](skills/ui/SKILL.md) | Explores, builds, and refines UI. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Creates new agent skills with proper structure. |
| [`writing-web-documentation`](skills/writing-web-documentation/SKILL.md) | Writes and organizes developer-facing web docs. |
| [`zoom-out`](skills/zoom-out/SKILL.md) | Gives broader context or a higher-level perspective. |

## Coordination patterns

- `grill-with-docs` can pause a design grilling loop and recommend `ecosystem-research` when external precedent would change an API, architecture, developer-experience, or platform decision.
- `grill-with-docs` should reconcile linked handoffs and parallel-session context before continuing with design questions.
- `simplify` routes high-impact simplifications through `validate-direction` before edits when the change affects public API, test policy, PR scope, domain language, or ADR-backed direction.
- `codex-session-finder` includes an active-worktree lookup recipe so PR and stack workflows can avoid mutating worktrees still owned by active Codex sessions.

## References

These skills build on patterns and ideas from:

- [fpgarciamtnz/World-of-Sofia](https://github.com/fpgarciamtnz/World-of-Sofia)
- [mattpocock/skills](https://github.com/mattpocock/skills)
