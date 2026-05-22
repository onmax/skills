# Evidence Lens

## Purpose

Check whether the direction is supported by separated facts, constraints, assumptions, and missing evidence.

## Questions

- What is directly known from the conversation, code, docs, or sources?
- What constraints did the user state?
- Which claims are still assumptions?
- Which assumptions matter enough to block writing or acting?
- What evidence would upgrade the weakest assumption?

## Output

Write `reports/evidence.md` with:

1. Verified facts
2. Constraints
3. Unresolved assumptions
4. Missing evidence
5. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as evidence.

Prefer `pause` when the direction depends on an unverified assumption that could reverse the decision.
