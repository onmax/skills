---
name: ecosystem-research
description: Researches how comparable external systems solve a design problem and returns decision-oriented patterns with sources. Use during design, grilling, or architecture work when the user asks how others solve this, asks to research the ecosystem, compare libraries/products, investigate technical writing, or gather external evidence for a decision.
---

# Ecosystem Research

## Quick Start

Use this when a design or grilling decision depends on how comparable external systems solve the same class of problem.

## Workflow

1. Form a concrete research question from the active design branch.
2. Choose a research depth: `targeted`, `standard`, or `ambitious`.
3. Identify the absolute project root and create a persisted research brief.
4. Spawn subagents according to the depth and source-area split.
5. Have subagents write reports under the research folder.
6. Verify every expected report exists and meets the evidence bar before synthesis.
7. Synthesize the reports into a concise `synthesis.md` when findings are substantive.
8. Return decision-oriented findings to the active session and continue with one question.

Do not mutate the project repo. Research artifacts belong under the temporary directory of the user's OS, not the current workspace. Resolve it with the platform temp-dir API or environment, such as `$TMPDIR` on macOS/Linux or `%TEMP%` on Windows. If subagents are unavailable, state that and do a compact local fallback.

## Research Depth

Default to `standard` unless the user asks for "quick", "ambitious", "proper research", "deep research", or the decision is public API, security, data model, migration, pricing, irreversible architecture, or high-conflict.

- `targeted`: one narrow source area, at least one subagent, at least 5 authoritative sources, one report, synthesis optional.
- `standard`: 2-4 distinct source areas, 2-4 subagents when available, at least 12 authoritative sources total, synthesis required.
- `ambitious`: broad or high-stakes work, 4+ source areas, 4+ subagents when available or staged local passes, at least 20 authoritative sources total, synthesis required, explicit evidence-versus-inference table required.

If the user says the first pass was too shallow, immediately upgrade to `ambitious`. Do not repeat the same source area with a slightly longer prompt; add missing source areas and stronger completion checks.

## Artifact Layout

Use this layout:

```text
<os-temp-dir>/ecosystem-research/<project>/<topic>/
+-- brief.md
+-- sources/
+-- reports/
+-- synthesis.md
```

`brief.md` should include the project/context name, absolute `project_root`, active design question, relevant conversation history, user concerns, resolved decisions, unresolved branches, research questions, chosen depth, source-area matrix, minimum source bar, report paths, and source priorities.

Because research artifacts live outside the project workspace, any project file reference in the brief, reports, synthesis, or subagent prompt must be absolute, such as `/Users/maxi/vitehub/vitehub/.agents/contexts/devtools/CONTEXT.md`. Never use repo-relative paths like `.agents/...` inside temporary artifacts unless they are paired with the absolute `project_root`.

Subagents should read `brief.md`.

For source-area matrices, report requirements, source-quality rules, and completion checks, use [RESEARCH-RIGOR.md](RESEARCH-RIGOR.md).

## Subagent Brief

Each subagent prompt should include the `brief.md` path, assigned source area, report path, chosen depth, source minimum for that area, whether source cloning into `sources/` is useful, a no-repo-mutation requirement, and a request for source links, trade-offs, patterns, disagreements, recommendations, and evidence-versus-inference separation.

Use at least one subagent. Use multiple subagents when source areas are meaningfully independent, such as framework ecosystems, product ecosystems, company technical writing, benchmarks, and security literature.

Subagents must write the requested report file. A progress message without a report is incomplete.

## Synthesis

Write `synthesis.md` when reports contain substantive evidence. Keep it concise and decision-oriented:

- consensus patterns
- meaningful disagreements
- applicability to this project
- risks and trade-offs
- evidence versus inference
- finding verdicts: `SUPPORTED`, `CONTESTED`, `WEAK`, or `INCONCLUSIVE`
- source-area coverage and gaps
- decision-changing evidence separated from background context
- recommended decision wording
- source links

If an ADR follows, tell the active grilling skill which learnings are worth carrying into the ADR. Do not write project ADRs directly from this skill.

## Output Shape

Return a compact answer:

```md
Research artifacts:
- Brief: <os-temp-dir>/ecosystem-research/<project>/<topic>/brief.md
- Synthesis: <os-temp-dir>/ecosystem-research/<project>/<topic>/synthesis.md

Findings:
- ...

Decision pressure:
- ...

Next grilling question:
...
```
