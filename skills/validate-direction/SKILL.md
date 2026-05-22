---
name: validate-direction
description: Validates an emerging direction through evidence, precedent, synthesis, and communication lenses before it is written down or acted on. Use near the end of grilling, planning, ADR, PRD, issue, or implementation-design work when the user wants the conclusion challenged before crystallizing it.
---

# Validate Direction

## Quick Start

Use this near the end of a design or grilling session, before the parent skill writes an ADR, PRD, issue plan, implementation plan, or final recommendation.

This skill does not write project docs directly. It produces a validation trail and hands findings back to the active parent skill.

## Workflow

1. Identify the project, topic, absolute project root, emerging direction, intended artifact, and open doubts.
2. Create `/tmp/validate-direction/<project>/<topic>/brief.md`.
3. Choose intensity and state it.
4. Spawn subagents when available.
5. Have lens agents write reports under `reports/`.
6. Write `verdict.md`.
7. Return the verdict to the active parent skill and continue with the next action or question.

If subagents are unavailable, state that and run the lenses locally.

## Artifact Layout

```text
/tmp/validate-direction/<project>/<topic>/
+-- brief.md
+-- reports/
|   +-- evidence.md
|   +-- precedent.md
|   +-- synthesis.md
|   +-- communication.md
+-- verdict.md
```

`brief.md` should include the relevant conversation history, user concerns, resolved decisions, unresolved doubts, intended artifact, and the direction being validated.

Because validation artifacts live under `/tmp`, `brief.md` must also include `project_root` as an absolute path. Any project file reference in the brief, reports, verdict, or subagent prompt must be absolute, such as `/Users/maxi/vitehub/vitehub/.agents/adr/0013-hosted-vitehub-devtools-client.md`. Never use repo-relative paths like `.agents/...` inside `/tmp` artifacts unless they are paired with the absolute `project_root`.

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

Use plain lens names in user-facing output. Philosopher-derived names may be treated as inspiration only.

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

## Output Shape

```md
Validation artifacts:
- Brief: /tmp/validate-direction/<project>/<topic>/brief.md
- Verdict: /tmp/validate-direction/<project>/<topic>/verdict.md

Verdict: proceed | revise | pause

Why:
- ...

Next:
...
```
