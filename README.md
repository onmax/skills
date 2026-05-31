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
| Clarify direction | Shared understanding, vocabulary, maybe an ADR | `design-to-agent-work`, `grill-with-docs`, `evidence-research`, `codex-session-finder`, `handoff` |
| Capture durable memory | `.agents/CONTEXT.md` terms and atomic ADRs | `grill-with-docs`, `validate-direction` |
| Shape agent work | GitHub issues as executable work contracts | `shape-agent-work` |
| Run agents | Branches and PRs from autonomous work | `sandcastle`, `sandcastle-workflow`, `vps-connection`, `pr-body` |
| Refine PRs | Autonomous PR cleanup and checks | `sandcastle-workflow`, `pr-refiner`, `pr-body` |
| Check merge readiness | Autonomous consumer-facing proof before merge | `sandcastle-workflow`, `pre-merge-validation`, `pr-stack-coordinator` |
| Merge command | Consent-gated rebase/squash/merge execution | `pr-stack-coordinator` |

`validate-direction` is not a phase. Use it whenever a direction is about to harden into docs, issues, code, PR strategy, or merge action.

### Minimal issue states

The first workflow iteration keeps GitHub labels intentionally small:

| Label | Meaning |
| --- | --- |
| `needs-info` | The issue is not executable yet. |
| `ready-for-agent` | The issue has enough context and acceptance criteria for autonomous work. |
| `in-agent-run` | Sandcastle or remote Codex is actively working on it. |
| `blocked` | Execution cannot continue without a human decision, access, dependency, or repo-state fix. |

When an autonomous run succeeds, it opens a PR with automatic issue linking such as `Closes #123`, refines the PR, runs needed merge-readiness validation, removes `in-agent-run`, and intentionally leaves the open issue without a workflow label. The issue stays open until the PR merges.

## Included skills

| Skill | What it does |
| --- | --- |
| [`codex-session-finder`](skills/codex-session-finder/SKILL.md) | Finds local Codex sessions for review. |
| [`evidence-research`](skills/evidence-research/SKILL.md) | Researches internal or external evidence for a decision. |
| [`design-to-agent-work`](skills/design-to-agent-work/SKILL.md) | Orchestrates direction clarification, durable memory, and agent-ready issue shaping. |
| [`fast-forward`](skills/fast-forward/SKILL.md) | Skips obvious branches during grilling sessions. |
| [`grill-me`](skills/grill-me/SKILL.md) | Interrogates a plan one decision at a time. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Stress-tests a plan and captures project language. |
| [`handoff`](skills/handoff/SKILL.md) | Captures continuation notes for another agent or session. |
| [`library-craft`](skills/library-craft/SKILL.md) | Reviews reusable package shape and public API craft. |
| [`people-skills`](skills/people-skills/SKILL.md) | Drafts relationship-preserving messages and interpersonal next actions. |
| [`pr-body`](skills/pr-body/SKILL.md) | Writes or reviews PR bodies in the repository's preferred style. |
| [`pr-refiner`](skills/pr-refiner/SKILL.md) | Reviews PR blockers and routes the next refinement step. |
| [`pr-stack-coordinator`](skills/pr-stack-coordinator/SKILL.md) | Coordinates stacked PRs, worktrees, ADR indexes, merge commands, and per-PR merge confirmation. |
| [`pre-merge-validation`](skills/pre-merge-validation/SKILL.md) | Runs consumer-install validation before merging PRs. |
| [`sandcastle`](skills/sandcastle/SKILL.md) | Explains and applies Sandcastle concepts for isolated agent execution. |
| [`sandcastle-workflow`](skills/sandcastle-workflow/SKILL.md) | Runs ready-for-agent issues through Sandcastle or remote Codex and opens linked PRs. |
| [`shape-agent-work`](skills/shape-agent-work/SKILL.md) | Converts clarified direction into GitHub issues for autonomous agents. |
| [`simplify`](skills/simplify/SKILL.md) | Finds the smallest useful simplification for a PR or scope. |
| [`setup-onmax-skills`](skills/setup-onmax-skills/SKILL.md) | Sets up lightweight repo-local guidance for Onmax skills. |
| [`codex-skill-retrospective`](skills/codex-skill-retrospective/SKILL.md) | Reviews Codex sessions and GitHub activity to improve skills. |
| [`strict-code-review`](skills/strict-code-review/SKILL.md) | Runs a strict maintainability review for structural quality and code-judo simplifications. |
| [`validate-direction`](skills/validate-direction/SKILL.md) | Challenges a direction before it becomes a plan or doc. |
| [`worktree-cleanup`](skills/worktree-cleanup/SKILL.md) | Safely cleans current-repo worktrees, stale branches, remote workspaces, and disk-heavy artifacts. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Creates agent skills with proper structure and review checks. |
| [`vps-connection`](skills/vps-connection/SKILL.md) | Discovers and verifies VPS/SSH access and remote Codex helpers. |

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
