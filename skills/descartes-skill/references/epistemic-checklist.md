# Epistemic Checklist

Use this checklist before presenting a planning foundation ledger or final plan.

## Planning Foundation Ledger

1. List candidate planning claims.
2. Make each claim atomic.
3. Assign one evidence state: `Observado`, `Inferido`, or `Desconocido`.
4. Promote only `Observado` facts to `Foundation-Fact`.
5. Promote only explicit user goals or constraints to `Foundation-Constraint`.
6. Put hypotheses, guesses, and unsupported claims in `Non-Foundations`.
7. Attach an evidence trace to every `Foundation-Fact`.
8. Attach the user's explicit instruction to every `Foundation-Constraint`.
9. Add a minimum upgrade path for every `Not Foundation`.

## Planning Gate

Before final plan output, ask one structured choice question with exactly:

- `Yes, audit`
- `Great`
- `Something else`

Apply the selected behavior:

- `Yes, audit`: run an assumption audit and revise the plan if needed.
- `Great`: return the final plan directly.
- `Something else`: ask one short follow-up and adapt the final plan.

## Assumption Audit

When the planning gate requests an assumption audit:

1. Enumerate assumptions that could affect the plan.
2. Check what evidence supports or contradicts each assumption.
3. Use only `Factual`, `Not Factual`, or `Unresolved`.
4. Revise any plan decision that depends on `Not Factual`.
5. Mark or ask about any plan decision that depends on `Unresolved`.

## Guardrail

Never assert third-party presence, assistance, persistence, file state, tool behavior, or external facts without direct evidence.
