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
| Clarify direction | Shared understanding or a requested project artifact | `grill-with-docs`, `evidence-research`, `validate-direction`, `handoff` |
| Design the codebase | A coherent domain, module interface, or architecture | `codebase-design`, `library-craft` |
| Write and refine engineering work | Actionable requests and focused review | `engineering-writing`, `code-review`, `pull-request` |
| Review reusable code | Package, SDK, or public API review | `library-craft`, `validate-direction` |
| Clean workspaces | Worktree, branch, cache, and disk cleanup | `cleanup` |

`validate-direction` is not a phase. Use it whenever a direction is about to harden into docs, issues, code, PR strategy, or merge action.

## Included skills

| Skill | What it does |
| --- | --- |
| [`airtable-cli`](skills/airtable-cli/SKILL.md) | Uses Airtable's official CLI to discover and run live record, comment, table, and field operations. |
| [`airtable-flow`](skills/airtable-flow/SKILL.md) | Advances Quiver Airtable tasks through a decision-gated lifecycle with automatic CLI state transitions. |
| [`agent-writing`](skills/agent-writing/SKILL.md) | Writes compact prompts and progressively disclosed skills. |
| [`animation`](skills/animation/SKILL.md) | Designs, finds, audits, implements, and reviews interface animation. |
| [`cli-craft`](skills/cli-craft/SKILL.md) | Builds command-line interfaces around explicit contracts and executable proof. |
| [`cleanup`](skills/cleanup/SKILL.md) | Safely cleans worktrees, branches, build artifacts, caches, and disk usage. |
| [`code-review`](skills/code-review/SKILL.md) | Reviews a diff for behavior, scope, structure, standards, and proof. |
| [`codebase-design`](skills/codebase-design/SKILL.md) | Designs deep modules, domain models, ownership, and test seams. |
| [`copywriting`](skills/copywriting/SKILL.md) | Writes clear, conversion-focused marketing copy for web pages. |
| [`delegate`](skills/delegate/SKILL.md) | Delegates one conversation-grounded PR to a separate Codex task. |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) | Runs the Matt Pocock diagnosis loop for hard bugs and performance regressions. |
| [`engineering-writing`](skills/engineering-writing/SKILL.md) | Turns verified evidence into actionable issue reports, implementation requests, and PR bodies. |
| [`evidence-research`](skills/evidence-research/SKILL.md) | Researches internal or external evidence for a decision. |
| [`fleet`](skills/fleet/SKILL.md) | Converges shared Linux coding nodes and agent profiles. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and writes only the artifact the user requested. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`people-skills`](skills/people-skills/SKILL.md) | Drafts relationship-preserving messages and interpersonal next actions. |
| [`portal-preview-login`](skills/portal-preview-login/SKILL.md) | Authenticates Browser to Quiver Portal pull-request previews. |
| [`pull-request`](skills/pull-request/SKILL.md) | Reviews contribution fit and converges one existing PR toward readiness. |
| [`prototype`](skills/prototype/SKILL.md) | Builds throwaway prototypes to answer design questions. |
| [`teach`](skills/teach/SKILL.md) | Teaches a skill or concept through a stateful teaching workspace. |
| [`ui`](skills/ui/SKILL.md) | Routes UI work to the smallest useful design/reference workflow. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |
| [`vitehub-drop`](skills/vitehub-drop/SKILL.md) | Uploads local images to permanent public Drop URLs for GitHub content. |
| [`vitehub-projects`](skills/vitehub-projects/SKILL.md) | Resolves ViteHub project aliases to local repository roots. |
| [`writing-documentation`](skills/writing-documentation/SKILL.md) | Writes developer documentation around the reader's goal with concrete technical English and verified examples. |
| [`writing-great-skills`](skills/writing-great-skills/SKILL.md) | Provides Matt Pocock's reference for writing and editing predictable skills. |

## Manual cleanup

Use `cleanup` from the repo you want to clean:

```text
Use cleanup here. Clean this repo locally, then clean the shared VPS workspace if relevant. Preserve dirty, untracked, or unique local work and report it first.
```

The skill defaults to the current session repository for manual cleanup. Daily automation can broaden the scope to common local roots and `/home/workspace` on the VPS.

## References

These skills build on patterns and ideas from:

- [fpgarciamtnz/World-of-Sofia](https://github.com/fpgarciamtnz/World-of-Sofia)
- [emilkowalski/skills](https://github.com/emilkowalski/skills)
- [mattpocock/skills](https://github.com/mattpocock/skills)
