# Implementation request

Write for the engineer deciding how to deliver a known outcome. If the direction, ownership, or trade-off is still open, validate it before presenting the request as settled.

## Content order

1. Open with the problem or use case, the requested observable result, and why it matters.
2. Describe the current behavior only as far as needed to locate the gap.
3. Define the smallest coherent scope, including a meaningful out-of-scope boundary when adjacent work is easy to confuse with it.
4. State constraints and settled decisions that change the implementation. Include a suggested solution or alternatives only when they are settled or change the decision.
5. Give acceptance criteria as observable behavior, supported by a fixture, screenshot, log shape, or other reproducible reference.
6. Link source evidence and useful code paths near the claims they support.

Use a natural paragraph for a small request. Add headings or bullets only when scope, constraints, and acceptance are substantial enough to be separate decisions.

## Visuals

- Use a current-state screenshot when the gap is visual and otherwise hard to recognize.
- Add a target reference when it communicates layout, hierarchy, or interaction more precisely than prose.
- Do not turn an exploratory mockup into a pixel-perfect requirement unless the direction explicitly requires that fidelity.

## Boundaries

- Keep implementation detail out unless it is a settled constraint or prevents the wrong ownership choice.
- Do not expand a focused request into a roadmap, ADR, or multi-ticket specification. Route complex planning to the appropriate planning skill.
- State unknowns that could change scope instead of burying them in acceptance criteria.
