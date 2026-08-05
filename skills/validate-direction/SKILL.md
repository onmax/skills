---
name: validate-direction
description: Challenges a proposed technical or product direction before it hardens into an API, workflow, architecture, plan, or durable artifact. Use when competing boundaries or ownership choices could materially change the next action.
---

# Validate Direction

Test one direction while it is still cheap to change. Preserve the user's intended outcome and return the smallest correction that makes the next action coherent.

## Method

1. State the direction, lifecycle phase, authorized next action, constraints, and load-bearing unknowns.
2. Reuse repository evidence, history, tests, PR context, prior decisions, and direct user statements. Gather only evidence that could change the verdict.
3. Apply four lenses:
   - **Evidence:** facts versus assumptions, with the strongest uncertainty.
   - **Precedent:** local ownership and comparable external precedent, including intentional breaks.
   - **Synthesis:** responsibility, boundaries, dependencies, invariants, and the smallest coherent correction.
   - **Communication:** wording, scope, trade-offs, and whether the next reader will act correctly.
4. Choose exactly one verdict: `proceed`, `revise`, or `pause`.

Use an inline advisory pass for a narrow, reversible choice. When the user explicitly requests a durable validation or the action is costly to reverse, load every file under `references/` and persist the brief, four lens reports, and verdict under `<os-temp-dir>/validate-direction/<project>/<topic>/`. Do not write project documentation.

Use `revise` when one concrete correction resolves the risk. Use `pause` only when an unanswered question could reverse the direction. After `proceed` or an in-scope `revise`, carry the verdict into the already-authorized work; do not turn validation into a new approval gate.

Lead with the verdict, then the decisive evidence, required correction, one line per lens, and the next authorized action. Ask one question only for `pause`.
