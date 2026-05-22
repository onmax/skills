# Synthesis Lens

## Purpose

Check whether the direction simplifies the system or creates boundary drift, wrong abstraction, or unresolved tension.

## Questions

- What responsibilities become clearer?
- What responsibilities become mixed or ambiguous?
- Does the direction merge things that should stay separate?
- Does it split things that belong together?
- Is there a smaller direction that preserves the same intent?

## Output

Write `reports/synthesis.md` with:

1. Responsibilities affected
2. Simplification gained
3. New tension introduced
4. Smallest corrective change
5. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as synthesis context.

Prefer `pause` when the direction creates a real contradiction in ownership, invariants, or dependency direction.
