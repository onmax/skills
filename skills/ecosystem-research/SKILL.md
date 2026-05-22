---
name: ecosystem-research
description: Researches how comparable external systems solve a design problem and returns decision-oriented patterns with sources. Use during design, grilling, or architecture work when the user asks how others solve this, asks to research the ecosystem, compare libraries/products, investigate technical writing, or gather external evidence for a decision.
---

# Ecosystem Research

## Quick Start

Use this as a companion skill for design and grilling sessions when the next decision depends on how comparable systems solve the same class of problem.

`zoom-out` maps the current project. `ecosystem-research` maps comparable external systems.

## Workflow

1. Form a concrete research question from the active design branch.
2. Identify the absolute project root and create a persisted research brief.
3. Spawn at least one subagent.
4. Use one subagent per distinct source area or domain when the comparison naturally splits.
5. Have subagents write reports under the research folder.
6. Synthesize the reports into a concise `synthesis.md` when findings are substantive.
7. Return decision-oriented findings to the active session and continue with one question.

Do not mutate the project repo. Research artifacts belong under `/tmp`. If subagents are unavailable, state that and do a compact local fallback.

## Artifact Layout

Use this layout:

```text
/tmp/ecosystem-research/<project>/<topic>/
+-- brief.md
+-- sources/
+-- reports/
+-- synthesis.md
```

`brief.md` should include the project/context name, absolute `project_root`, active design question, relevant conversation history, user concerns, resolved decisions, unresolved branches, research questions, and source priorities.

Because research artifacts live under `/tmp`, any project file reference in the brief, reports, synthesis, or subagent prompt must be absolute, such as `/Users/maxi/vitehub/vitehub/.agents/contexts/devtools/CONTEXT.md`. Never use repo-relative paths like `.agents/...` inside `/tmp` artifacts unless they are paired with the absolute `project_root`.

Subagents should read `brief.md`.

## Subagent Brief

Each subagent prompt should include the `brief.md` path, assigned source area, report path, whether source cloning into `sources/` is useful, a no-repo-mutation requirement, and a request for source links, trade-offs, patterns, and recommendations.

Use at least one subagent. Use multiple subagents only when the source areas are meaningfully independent, such as framework ecosystems, product ecosystems, and company technical writing.

## Source Guidance

Prefer authoritative and current sources: official docs, source repositories, technical blogs from relevant companies, design notes, RFCs, changelogs, and established comparable libraries or products.

"Others" means comparable systems facing a similar design challenge. Ask the subagent to justify why each comparison is relevant.

## Synthesis

Write `synthesis.md` when reports contain substantive evidence. Keep it concise and decision-oriented:

- consensus patterns
- meaningful disagreements
- applicability to this project
- risks and trade-offs
- recommended decision wording
- source links

If an ADR follows, tell the active grilling skill which learnings are worth carrying into the ADR. Do not write project ADRs directly from this skill.

## Deep Research

If the question is broad, high-stakes, or likely to need long-running research, suggest a deeper human-approved research workflow. Do not trigger deep research without explicit user approval.

## Output Shape

Return a compact answer:

```md
Research artifacts:
- Brief: /tmp/ecosystem-research/<project>/<topic>/brief.md
- Synthesis: /tmp/ecosystem-research/<project>/<topic>/synthesis.md

Findings:
- ...

Decision pressure:
- ...

Next grilling question:
...
```
