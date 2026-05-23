# Cartesian AI Operationalization

## Goal

Map Cartesian epistemic discipline to practical planning foundation ledger behavior.

The useful rule is simple: do not let the plan assert more than the evidence supports.

## Evidence States

- `Observado`: directly supported by traceable evidence.
- `Inferido`: reasoned from available evidence, but not directly verified.
- `Desconocido`: unsupported, unavailable, or unverifiable in the current context.

## Planning Foundation Rules

A claim can enter the foundation layer only when it is one of these:

1. `Foundation-Fact`
   - Must be `Observado`.
   - Must include an evidence trace.
2. `Foundation-Constraint`
   - Must come from an explicit user instruction, goal, or boundary.
3. `Not Foundation`
   - Anything else.

This keeps the planning foundation ledger and final plan from quietly depending on guesses.

## Assent Control

Use assent control to decide what the assistant may safely assert:

- Assert when evidence is `Observado`.
- Hedge or mark as an assumption when evidence is `Inferido`.
- Withhold, ask, or list as missing data when evidence is `Desconocido`.

## Upgrade Paths

Every `Not Foundation` in the planning foundation ledger needs a practical upgrade path. Good upgrade paths name the smallest useful check:

- Inspect a specific file or config.
- Run a non-mutating command.
- Ask the user for a missing product preference.
- Verify behavior with a focused test.
- Check an external source when current facts may have changed.

## Planning Risk Rule

If a major plan step depends on `Inferido` or `Desconocido`, the planning foundation ledger or final plan must either:

- mark the dependency as an assumption,
- include a verification step before implementation, or
- ask for the missing evidence before finalizing.

## Spanish Voice

The original voice can remain partly Spanish. Prefer the operational labels `Observado`, `Inferido`, and `Desconocido`, even when the rest of the answer is in English.
