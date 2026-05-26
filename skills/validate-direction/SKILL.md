---
name: validate-direction
description: Challenges a direction before it hardens into work or documentation. Use before plans, ADRs, PRDs, issue breakdowns, API changes, merge strategy, workflow rules, or durable docs.
---

# Validate Direction

## Quick Start

Use this as a lifecycle checkpoint whenever a direction is about to become costly to unwind. It is not owned by `grill-with-docs`; that skill is only one caller.

Good trigger points include:

- Before writing or updating an ADR, PRD, issue plan, implementation plan, or final recommendation.
- Before acting on a design, API, workflow, merge, testing, or documentation direction that will shape later work.
- During implementation when new evidence changes the direction, not merely the code.
- During review or PR coordination before accepting a merge strategy, dependency relationship, broad refactor, or durable follow-up plan.

The goal is not to make the plan sound better. The goal is to find the strongest reason it might be wrong, vague, or premature while it is still cheap to change.

Keep it practical. Do not add philosophical commentary. Do not re-run the whole planning session. Validate the current direction, name the exact weakness, then return the smallest useful correction.

Do not use this for every small edit. Skip it when the work is local, reversible, already specified, or only mechanical.

## Workflow

1. State the direction being validated in one plain sentence.
2. Identify the project, topic, absolute project root, lifecycle phase, intended artifact or action, user constraints, known evidence, and open doubts.
3. Create `<os-temp-dir>/validate-direction/<project>/<topic>/brief.md`, where `<os-temp-dir>` is the temporary directory of the user's OS.
4. Choose intensity and state it.
5. Run the four lenses: Evidence, Precedent, Synthesis, and Communication.
6. Write `verdict.md`.
7. Return the verdict and either continue with the parent skill's next action or ask one blocking question.

Subagents are optional. Use them when available and useful, but do not block on them. If they are unavailable, state that and run the lenses locally.

This skill does not write project docs directly. It hands wording and required changes back to the active skill or session.

## Artifact Layout

```text
<os-temp-dir>/validate-direction/<project>/<topic>/
+-- brief.md
+-- reports/
|   +-- evidence.md
|   +-- precedent.md
|   +-- synthesis.md
|   +-- communication.md
+-- verdict.md
```

`brief.md` should include the relevant conversation history, user concerns, resolved decisions, unresolved doubts, lifecycle phase, intended artifact or action, and the direction being validated.

Because validation artifacts live outside the project workspace, `brief.md` must also include `project_root` as an absolute path. Any project file reference in the brief, reports, verdict, or subagent prompt must be absolute, such as `/Users/maxi/vitehub/vitehub/.agents/adr/0013-hosted-vitehub-devtools-client.md`. Never use repo-relative paths like `.agents/...` inside temporary artifacts unless they are paired with the absolute `project_root`.

Resolve `<os-temp-dir>` with the platform temp-dir API or environment, such as `$TMPDIR` on macOS/Linux or `%TEMP%` on Windows.

## Intensity

Choose automatically:

- `light`: one subagent runs all lenses for small, low-risk directions.
- `standard`: four subagents, one per lens. Default for meaningful architecture or product direction.
- `heavy`: four lens subagents plus synthesis coordination or a second pass for public API, migration, security, data model, irreversible architecture, or high-conflict decisions.

State the choice before spawning.

## Lenses

Load the reference file for each active lens:

- Evidence: [references/evidence.md](references/evidence.md)
- Precedent: [references/precedent.md](references/precedent.md)
- Synthesis: [references/synthesis.md](references/synthesis.md)
- Communication: [references/communication.md](references/communication.md)

Use plain lens names in user-facing output.

Apply the lenses like this:

- **Evidence**: separate facts, constraints, assumptions, and missing observations. This borrows the useful part of an assumption audit: do not let an inference pretend to be a fact.
- **Precedent**: check the direction against local project language, existing patterns, and comparable external systems. Do not reward consistency blindly; name intentional breaks.
- **Synthesis**: ask whether the direction makes the system more coherent. Look for responsibility drift, wrong abstraction, dependency confusion, or a smaller coherent direction.
- **Communication**: check whether the future reader will know what to do, what not to do, and why. Rewrite the decision sentence if the current wording invites a wrong move.

Keep the roles distinct. Evidence answers "what do we know?" Precedent answers "what are we extending or breaking?" Synthesis answers "does this make the system simpler in the right place?" Communication answers "will the next reader act correctly?"

## Verdict

`verdict.md` must choose exactly one:

- `proceed`: coherent enough to write or act on.
- `revise`: direction is basically right, but specific changes are needed first.
- `pause`: risks are serious enough that the parent session should ask another question before writing or acting.

Include:

- verdict
- key evidence
- required changes
- risks
- wording to carry into the artifact
- one final question, if needed

## Review Rules

- Start from the actual direction, not a better direction you wish existed.
- Preserve the user's intent unless evidence shows it is unsafe, incoherent, or underspecified.
- Prefer `revise` over `pause` when a concrete wording, scope, or boundary change would fix the issue.
- Prefer `pause` only when one unanswered question could reverse the decision.
- Do not block on harmless uncertainty. Name it and proceed.
- Do not produce a long essay. The output should make the next move obvious.
- If the active skill is `grill-with-docs`, return the decision sentence and any ADR-worthy trade-off.
- If the active skill is `evidence-research`, carry forward only findings that change the decision pressure.
- If the active work is implementation planning, include the tests or checks that would protect the decision.
- If the active work is implementation, distinguish code-level execution from direction change; validate only the latter.
- If the active work is review, PR coordination, or merge readiness, include the evidence that would make the recommendation safe to act on.

## Output Shape

```md
Validation artifacts:
- Brief: <os-temp-dir>/validate-direction/<project>/<topic>/brief.md
- Verdict: <os-temp-dir>/validate-direction/<project>/<topic>/verdict.md

Verdict: proceed | revise | pause

Why:
- ...

Next:
...
```
