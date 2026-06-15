![Onmax Skills](https://raw.githubusercontent.com/onmax/skills/main/.github/onmax-skills-hero.png)

A growing collection of agent skills from my work on ViteHub, Nuxt, auth, validation, Nimiq, and AI coding tools.

```sh
npx skills add onmax/skills
```

## Agent work lifecycle

![Onmax Agent Work Lifecycle](https://raw.githubusercontent.com/onmax/skills/main/.github/onmax-agent-work-lifecycle.png)

These skills are meant to compose into a lightweight delivery loop:

| Phase | Artifact | Main skills |
| --- | --- | --- |
| Clarify direction | Shared understanding, vocabulary, maybe an ADR | `grill-me`, `grill-with-docs`, `evidence-research`, `codex-session-finder`, `handoff` |
| Capture durable memory | `.agents/CONTEXT.md` terms and atomic ADRs | `grill-with-docs`, `validate-direction` |
| Refine PRs | Focused PR cleanup and checks | `pr-refiner`, `pr-body`, `strict-code-review`, `simplify` |
| Review reusable code | Package, SDK, or public API review | `library-craft`, `validate-direction` |
| Clean workspaces | Worktree and build artifact cleanup | `worktree-cleanup` |

`validate-direction` is not a phase. Use it whenever a direction is about to harden into docs, issues, code, PR strategy, or merge action.

## Included skills

| Skill | What it does |
| --- | --- |
| [`codex-session-finder`](skills/codex-session-finder/SKILL.md) | Finds local Codex sessions for review. |
| [`evidence-research`](skills/evidence-research/SKILL.md) | Researches internal or external evidence for a decision. |
| [`fast-forward`](skills/fast-forward/SKILL.md) | Skips obvious branches during grilling sessions. |
| [`grill-me`](skills/grill-me/SKILL.md) | Interrogates a plan one decision at a time. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and captures project language. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`people-skills`](skills/people-skills/SKILL.md) | Drafts relationship-preserving messages and interpersonal next actions. |
| [`pr-body`](skills/pr-body/SKILL.md) | Writes or reviews PR bodies in the repository's preferred style. |
| [`pr-refiner`](skills/pr-refiner/SKILL.md) | Reviews PR blockers and routes the next refinement step. |
| [`simplify`](skills/simplify/SKILL.md) | Finds the smallest useful simplification for a PR or scope. |
| [`strict-code-review`](skills/strict-code-review/SKILL.md) | Runs a strict maintainability review for structural quality and code-judo simplifications. |
| [`ui-workflow-router`](skills/ui-workflow-router/SKILL.md) | Routes UI work to the right design/reference workflow. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |
| [`worktree-cleanup`](skills/worktree-cleanup/SKILL.md) | Safely cleans current-repo worktrees, stale branches, remote workspaces, and disk-heavy artifacts. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Creates agent skills with proper structure and review checks. |

## Manual cleanup

Use `worktree-cleanup` from the repo you want to clean:

```text
Use worktree-cleanup here. Clean this repo locally, then clean the shared VPS workspace if relevant. Preserve dirty, untracked, or unique local work and report it first.
```

The skill defaults to the current session repository for manual cleanup. Daily automation can broaden the scope to common local roots and `/home/workspace` on the VPS.

## References

These skills build on patterns and ideas from:

- [fpgarciamtnz/World-of-Sofia](https://github.com/fpgarciamtnz/World-of-Sofia)
- [mattpocock/skills](https://github.com/mattpocock/skills)
