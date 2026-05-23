---
name: skill-retrospective
description: Analyzes recent Codex sessions and GitHub activity to find repeated agent failures, weak skill instructions, missing workflows, and opportunities for new or improved skills. Use when the user asks to review recent Codex work, audit skill usage, analyze agent patterns, improve skills from session history, or run a daily/weekly skill retrospective.
---

# Skill Retrospective

Analyze recent Codex work to improve the skill ecosystem.

Default scope: the last 24 hours of Codex sessions. If the user gives a thread id, repo path, date range, branch, PR, issue, or topic, use that as the scope.

Default posture: exhaustive read-only analysis and suggestions. Do not edit skills, create issues, comment on GitHub, or push changes from this skill.

Primary evidence is Codex session history. GitHub is supporting evidence when Codex sessions mention or imply GitHub activity.

## Workflow

1. Resolve the retrospective scope:
   - time window, defaulting to the last 24 hours
   - Codex thread ids, titles, repo paths, rollout paths, or topics
   - GitHub repositories, branches, PRs, issues, commits, reviews, and failing checks only when linked from Codex activity
2. Retrieve Codex evidence:
   - Use `codex-session-finder` for specific thread ids, titles, repo paths, rollout paths, or topics.
   - For time-window scopes, query Codex session metadata first, then read in-scope rollout files.
   - Include archived sessions when they fall inside the scope.
   - Weight user prompts, corrections, redirects, approvals, and frustration signals more heavily than assistant narration.
3. Retrieve GitHub evidence:
   - Use `gh` or GitHub plugin capabilities to inspect related PRs, issues, commits, reviews, comments, and checks.
   - Link GitHub activity back to Codex sessions through branch names, repo paths, PR URLs, commit SHAs, and timestamps.
   - Inspect nearby related PRs when evidence suggests a stack or shared failure pattern, and label the scope expansion.
   - Attribute GitHub events by actor/source.
   - Do not post comments or mutate GitHub state.
4. Build an evidence ledger:
   - actions attempted
   - skills invoked or implied
   - tools used
   - user corrections
   - failed assumptions
   - repeated blockers
   - missing context
   - successful patterns worth preserving
5. For non-trivial runs, write temporary artifacts outside the repo:
   - place them under `$TMPDIR/skill-retrospective/<date-or-topic>/`
   - `scope.md`
   - `evidence-ledger.md`
   - `github-evidence.md`
   - `recommendations.md`
6. Use the reference guides:
   - [references/codex-evidence.md](references/codex-evidence.md)
   - [references/github-evidence.md](references/github-evidence.md)
   - [references/pattern-rubric.md](references/pattern-rubric.md)
7. Analyze patterns using [references/pattern-rubric.md](references/pattern-rubric.md).
   - Treat repeated patterns as actionable by default.
   - Treat one incident as actionable only when severity is high.
   - Put weak but suggestive evidence in `Investigations`.
8. For large retrospectives, optionally use scoped subagents:
   - split by repo, evidence source, or session cluster
   - ask each subagent for an evidence ledger, not final policy
   - synthesize and rank recommendations centrally
   - continue locally if subagents are unavailable
9. Recommend improvements:
   - edits to existing skills
   - new skill candidates
   - setup or routing changes
   - checks, CLI recipes, or reference docs
   - habits that should stay manual rather than become a skill

## Onmax Skill Routing

- Use `codex-session-finder` for targeted session retrieval.
- Use `pr-refiner` when the retrospective identifies a live PR that still needs refinement.
- Use `simplify` when a repeated failure is overbroad scope or accidental complexity.
- Use `strict-code-review` when repeated failures come from weak maintainability review.
- Use `grill-with-docs` when the fix requires better project language or ADR-backed decisions.
- Use `validate-direction` before turning a retrospective finding into a durable skill direction.
- Use `handoff` when the retrospective is too large to finish in the current session.

## Output

```md
Retrospective scope:
- ...

Evidence reviewed:
- Codex sessions: ...
- GitHub activity: ...
- Temporary artifacts: ...

Patterns:
1. <pattern>. Evidence: <session/thread/PR references>. Impact: <why it matters>.

Skill improvements:
1. `<skill>`: <specific edit or routing change>. Why: <pattern it addresses>.

New skill candidates:
1. `<name>`: <job>. Trigger: <when to use>. Why existing skills do not cover it.

Investigations:
1. <question to investigate>. Evidence: <why it is suggestive but not decisive>.

Keep:
- ...

Open questions:
- ... <!-- only when answers would change the recommendation -->

Apply only if asked:
- ...
```

## Rules

- Prefer evidence over vibes. Tie every recommendation to concrete sessions, user corrections, GitHub events, or repeated tool behavior.
- Be exhaustive in retrieval, but concise in the final report.
- Paraphrase private content by default; quote tiny excerpts only when exact wording proves a trigger or instruction problem.
- Include links and identifiers by default: thread ids, PR URLs, issue URLs, commit SHAs, branch names, timestamps, and file paths.
- Never include secrets, credentials, customer data, or unrelated personal content.
- Distinguish one-off mistakes from repeated patterns. A single incident justifies a recommendation only when severity is high.
- Do not create new skills for habits that fit an existing skill with a small routing or wording change.
- Do not edit skill files from this skill.
- Never post PR or issue comments without explicit consent.
