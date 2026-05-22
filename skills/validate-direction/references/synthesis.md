# Synthesis Lens

## Purpose

Check whether the direction makes the system more coherent. Look for responsibility drift, wrong abstraction, dependency inversion, hidden coupling, and unresolved tension.

This lens is the coherence critic: it asks "does this deepen the model, or does it move confusion somewhere harder to see?"

## Vocabulary

- **Responsibility**: what a module, package, document, or concept owns.
- **Boundary**: where one responsibility stops and another starts.
- **Invariant**: a rule that must stay true for the system to work.
- **Dependency direction**: which layer or package is allowed to know about another.
- **Abstraction depth**: whether a small surface area carries useful behavior.
- **Surface area**: what future callers, users, or maintainers must understand.
- **Coupling**: knowledge that spreads across boundaries.
- **Smallest coherent change**: the narrowest direction that preserves the intent without unresolved contradiction.

## Critical Posture

Do not ask whether the direction is elegant. Ask whether it reduces the right complexity at the right boundary.

Name the strongest architectural contradiction, then decide whether the direction survives it.

## Questions

- What responsibilities become clearer?
- What responsibilities become mixed or ambiguous?
- Which invariants does the direction introduce or protect?
- Does the dependency direction stay sane?
- Does the direction merge things that should stay separate?
- Does it split things that belong together?
- Does it deepen a useful abstraction or add surface area?
- Is there a smaller coherent direction that preserves the same intent?

## Failure Modes

- Moving complexity out of sight instead of reducing it.
- Creating a global mechanism for one local problem.
- Splitting one concept across multiple owners.
- Collapsing distinct responsibilities into one convenient package.
- Introducing an abstraction before there are real alternate implementations or callers.
- Leaving the decision correct in prose but contradictory in code ownership.

## Output

Write `reports/synthesis.md` with:

1. Responsibilities affected
2. Boundary and dependency effects
3. Invariants protected or introduced
4. Simplification gained
5. New tension introduced
6. Smallest coherent correction
7. Strongest coherence-based objection
8. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as synthesis context.

Prefer `proceed` when the direction clarifies ownership and keeps dependency direction coherent.
Prefer `revise` when the direction is right but needs a smaller scope, clearer boundary, or sharper invariant.
Prefer `pause` when the direction creates a real contradiction in ownership, invariants, or dependency direction.
