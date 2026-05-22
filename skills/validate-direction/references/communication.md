# Communication Lens

## Purpose

Check whether the direction will be understood correctly by future readers and whether the intended artifact frames the trade-off clearly.

## Questions

- What is the direction trying to make future readers understand?
- What could be misread or overgeneralized?
- Are trade-offs and rejected alternatives explicit enough?
- Is the wording too vague, too broad, or too implementation-heavy?
- What sentence should carry the decision?

## Output

Write `reports/communication.md` with:

1. Intended meaning
2. Likely misreadings
3. Friction points
4. Better decision wording
5. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as communication context.

Prefer `revise` when the direction is sound but the written artifact would invite the wrong future change.
