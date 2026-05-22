# Precedent Lens

## Purpose

Check whether the direction fits existing project patterns, vocabulary, ownership boundaries, and comparable external precedent.

This lens is the lineage critic: it asks "what tradition are we extending, what are we breaking, and is the break intentional?"

## Vocabulary

- **Local precedent**: existing code, docs, ADRs, naming, package boundaries, or workflows in this project.
- **Ecosystem precedent**: comparable libraries, frameworks, products, or company practices solving a similar problem.
- **Naming lineage**: whether the proposed terms continue the project's established language.
- **Boundary lineage**: whether ownership and responsibility follow an existing pattern.
- **Intentional break**: a deliberate departure that should be documented.
- **Accidental divergence**: a second pattern created without a real reason.
- **False friend**: familiar wording that hides a different responsibility.

## Critical Posture

Do not reward consistency blindly. Sometimes precedent is the thing that should be broken.

Name the nearest precedent, then say whether the direction should extend it, revise it, or explicitly break from it.

## Questions

- What existing project language should this direction use?
- Which modules, docs, ADRs, or workflows are the nearest local precedent?
- Which external systems are genuinely comparable, if any?
- Does the direction reuse, extend, contradict, or replace the precedent?
- Is similar wording hiding different responsibilities?
- Would this create a second pattern family without need?
- If this breaks precedent, is the reason strong enough to write down?

## Failure Modes

- Creating a new term when the project already has the right one.
- Reusing an old term for a new responsibility.
- Copying ecosystem precedent that solves a different problem.
- Treating accidental historical code shape as architectural intent.
- Breaking a project pattern without naming the break.

## Output

Write `reports/precedent.md` with:

1. Nearest local precedent
2. Relevant ecosystem precedent
3. Naming fit
4. Boundary fit
5. Accidental divergence or intentional break
6. Strongest precedent-based objection
7. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as precedent context.

Prefer `proceed` when the direction cleanly extends precedent or intentionally replaces weak precedent.
Prefer `revise` when the direction is good but needs naming, boundary, or migration alignment.
Prefer `pause` when the direction creates incompatible pattern families or contradicts a load-bearing ADR without acknowledging it.
