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
| Clarify direction | Shared understanding or a requested project artifact | `grill-me`, `grill-with-docs`, `evidence-research`, `codex-session-finder`, `handoff` |
| Capture requested project memory | A user-requested glossary, context map, or ADR | `domain-modeling`, `validate-direction` |
| Refine PRs | Focused PR cleanup and checks | `pr-refiner`, `pr-body`, `strict-code-review`, `simplify` |
| Review reusable code | Package, SDK, or public API review | `library-craft`, `validate-direction` |
| Clean workspaces | Worktree and build artifact cleanup | `worktree-cleanup` |

`validate-direction` is not a phase. Use it whenever a direction is about to harden into docs, issues, code, PR strategy, or merge action.

## Included skills

| Skill | What it does |
| --- | --- |
| [`code-review`](skills/code-review/SKILL.md) | Reviews a diff independently against repository standards and its originating spec. |
| [`codebase-design`](skills/codebase-design/SKILL.md) | Provides the shared vocabulary and methods for designing deep modules. |
| [`codex-session-finder`](skills/codex-session-finder/SKILL.md) | Finds local Codex sessions for review. |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) | Runs the Matt Pocock diagnosis loop for hard bugs and performance regressions. |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | Builds `.agents` domain language and ADRs. |
| [`evidence-research`](skills/evidence-research/SKILL.md) | Researches internal or external evidence for a decision. |
| [`fast-forward`](skills/fast-forward/SKILL.md) | Skips obvious branches during grilling sessions. |
| [`fleet`](skills/fleet/SKILL.md) | Converges shared Linux coding nodes and agent profiles. |
| [`grill-me`](skills/grill-me/SKILL.md) | Interrogates a plan one decision at a time. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and writes only the artifact the user requested. |
| [`grilling`](skills/grilling/SKILL.md) | Runs the shared grilling interview loop. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`implement`](skills/implement/SKILL.md) | Implements work from a spec or tickets, then reviews the result. |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | Finds and explores deepening opportunities in active code. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`people-skills`](skills/people-skills/SKILL.md) | Drafts relationship-preserving messages and interpersonal next actions. |
| [`pr-body`](skills/pr-body/SKILL.md) | Writes or reviews PR bodies in the repository's preferred style. |
| [`pr-comment-sentinel`](skills/pr-comment-sentinel/SKILL.md) | Runs an exact-head PR review and repair heartbeat. |
| [`pr-refiner`](skills/pr-refiner/SKILL.md) | Reviews PR blockers and routes the next refinement step. |
| [`prototype`](skills/prototype/SKILL.md) | Builds throwaway prototypes to answer design questions. |
| [`research`](skills/research/SKILL.md) | Delegates source-backed research and saves the findings in the repo. |
| [`resolving-merge-conflicts`](skills/resolving-merge-conflicts/SKILL.md) | Resolves merge and rebase conflicts from the intent of both sides. |
| [`setup-matt-pocock-skills`](skills/setup-matt-pocock-skills/SKILL.md) | Configures tracker, triage labels, and domain-doc layout for Matt-style engineering skills. |
| [`simplify`](skills/simplify/SKILL.md) | Finds the smallest useful simplification for a PR or scope. |
| [`strict-code-review`](skills/strict-code-review/SKILL.md) | Runs a strict maintainability review for structural quality and code-judo simplifications. |
| [`teach`](skills/teach/SKILL.md) | Teaches a skill or concept through a stateful teaching workspace. |
| [`to-spec`](skills/to-spec/SKILL.md) | Turns the current conversation into a tracker-backed spec. |
| [`to-tickets`](skills/to-tickets/SKILL.md) | Breaks a plan or spec into tracer-bullet tickets with blocking edges. |
| [`ui`](skills/ui/SKILL.md) | Routes UI work to the smallest useful design/reference workflow. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |
| [`vitehub-projects`](skills/vitehub-projects/SKILL.md) | Resolves ViteHub project aliases to local repository roots. |
| [`wayfinder`](skills/wayfinder/SKILL.md) | Charts large foggy efforts as a shared map of decision tickets. |
| [`workflow`](skills/workflow/SKILL.md) | Coordinates autonomous work across owned implementation slices. |
| [`worktree-cleanup`](skills/worktree-cleanup/SKILL.md) | Safely cleans current-repo worktrees, stale branches, remote workspaces, and disk-heavy artifacts. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Creates agent skills with proper structure and review checks. |
| [`writing-great-skills`](skills/writing-great-skills/SKILL.md) | Provides Matt Pocock's reference for writing and editing predictable skills. |

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
