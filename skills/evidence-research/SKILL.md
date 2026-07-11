---
name: evidence-research
description: Persists rigorous internal or external evidence for one decision. Use when design, planning, retrospectives, or architecture depends on sourced research before deciding.
---

# Evidence Research

Use this for one decision whose evidence must be gathered, checked, synthesized, and persisted before acting. Use ordinary lookup when only a few facts, examples, or links are needed.

## Steps

1. Announce the skill selection and why. This announces routing, not that research is already underway.
2. State one decision in a plain sentence. Name one to three reversing constraints: facts or constraints that would materially narrow or reverse it.
3. Treat every proposed mechanism as a hypothesis. Record the evidence that would falsify it.
4. Choose a source mode and research depth.
5. Load [RESEARCH-RIGOR.md](RESEARCH-RIGOR.md). Resolve the absolute project root and OS temporary directory, create the research directories and `brief.md`, and record concrete expected report paths before claiming research is underway.
6. Assign source areas and gather evidence under the rigor rules.
7. Apply the report gate. Synthesis begins only after every expected report passes it.
8. Write `synthesis.md` when the chosen depth requires it, including when the result is inconclusive. For `targeted` research, write it only when the reports contain substantive decision evidence.
9. Apply the synthesis gate whenever `synthesis.md` is written, then return findings and decision pressure before artifact paths. Include one next grilling question only when an active grilling session has a genuinely unresolved branch.

Send interim updates only when evidence changes the decision pressure or a blocker prevents completion.

Keep the project repository unchanged. Store research artifacts under the OS temporary directory, such as `$TMPDIR` on macOS/Linux or `%TEMP%` on Windows. If subagents are unavailable, state that and run the local fallback defined by the rigor rules.

## Source Modes

- `ecosystem`: external systems, libraries, products, docs, public precedent, and technical writing.
- `internal`: repository history, Codex sessions, PRs, issues, ADRs, local docs, and project-specific evidence.
- `mixed`: internal evidence plus external precedent.

Default to `ecosystem` when the user asks how others solve a problem, compares products or libraries, or requests ecosystem precedent. Default to `internal` for retrospectives, session analysis, project history, or repo-local patterns. Use `mixed` when both source families could change the decision.

## Research Depth

Default to `standard`. Scale depth with the decision's breadth, irreversibility, stakes, and cost of a wrong answer. Honor explicit requests for `targeted`, `standard`, `ambitious`, `quick`, or `deep` research.

- `targeted`: one narrow source area, at least 5 authoritative sources, synthesis optional.
- `standard`: one focused source area by default, at least 8 authoritative sources total, synthesis required. Add source areas only when they are independent and could change the decision.
- `ambitious`: broad or hard-to-reverse work, 4 or more decision-relevant source areas, at least 20 authoritative sources total, synthesis required, and an explicit evidence-versus-inference table.

A focused, reversible public API question can remain `targeted` or `standard`. Use `ambitious` when API breadth, migration cost, security, data-model impact, pricing, irreversible architecture, or conflict makes reversal expensive.

If the user says the first pass was too shallow, upgrade to `ambitious`, add missing source areas, and strengthen the completion checks.

## Artifact Layout

```text
<os-temp-dir>/evidence-research/<project>/<topic>/
+-- brief.md
+-- sources/
+-- reports/
+-- synthesis.md
```

Write these fields in `brief.md`:

- project or context name and absolute `project_root`
- the one decision being researched
- one to three reversing constraints
- relevant conversation history, user concerns, and resolved decisions
- unresolved branches and research questions
- mechanism hypotheses and their falsifiers
- source mode and depth
- source-area matrix, source priorities, and minimum source bar
- concrete expected report paths

Use absolute project file paths in briefs, reports, synthesis, and subagent prompts.

[RESEARCH-RIGOR.md](RESEARCH-RIGOR.md) is the single source of truth for source-area assignment, subagent prompts, report requirements, source quality, finding verdicts, and completion checks. Apply every relevant rule before accepting a report or synthesis.

## Synthesis

Keep `synthesis.md` concise and decision-oriented:

- consensus patterns and meaningful disagreements
- applicability to this project
- risks and trade-offs
- evidence separated from inference
- source-area coverage and gaps
- decision-changing evidence separated from background context
- recommended decision wording
- source links

Use the finding-verdict shape from [RESEARCH-RIGOR.md](RESEARCH-RIGOR.md) for every major claim. Return ADR-worthy trade-offs to the active caller; this skill does not write project ADRs.

## Output

```md
Findings:
- ...

Decision pressure:
- ...

Research artifacts:
- Brief: <os-temp-dir>/evidence-research/<project>/<topic>/brief.md
- Synthesis: <os-temp-dir>/evidence-research/<project>/<topic>/synthesis.md

Next grilling question:
...
```

Omit the synthesis path when no synthesis was required. Omit the next grilling question outside an active grilling session or when no unresolved branch remains.
