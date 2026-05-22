# Precedent Lens

## Purpose

Check whether the direction fits existing project patterns, vocabulary, ownership boundaries, and comparable precedent.

## Questions

- What existing project language should this direction use?
- Which modules, docs, ADRs, or patterns are the nearest precedent?
- Does the direction reuse, extend, or contradict that precedent?
- Is similar wording hiding different responsibilities?
- Would this create a second pattern family without need?

## Output

Write `reports/precedent.md` with:

1. Relevant precedent
2. Pattern fit
3. Vocabulary fit
4. Contradiction or duplication risks
5. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as precedent context.

Prefer `revise` when the direction is good but needs naming or boundary alignment.
