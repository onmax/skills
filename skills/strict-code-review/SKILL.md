---
name: strict-code-review
description: Reviews code for maintainability, structure, abstractions, large files, and cleanup opportunities. Use when the user asks for strict, harsh, deep, or ambitious code review.
---

# Strict Code Review

Use this skill for a strict review focused on implementation quality, maintainability, abstraction quality, and codebase health.

Default posture: review first. Do not edit files, post PR comments, approve, request changes, or merge unless the user explicitly asks for that follow-up.

Default scope is the current PR diff or current branch diff, including related uncommitted local changes. If the user gives an explicit scope, use that instead: a PR URL, pasted diff, file, package, module, component, plan, or current conversation direction.

For stacked branches, do not default to `main...HEAD` when that would include parent-branch work. Resolve the PR base/head, dependency branch, or explicit commit range first. Prefer the PR's actual changed commits, `HEAD^..HEAD`, or the user-provided range when the task is to review only the top stack item.

## Core Standard

Rethink how to structure or implement the change to meaningfully improve code quality without changing behavior.

Look for "code judo" moves: restructurings that preserve behavior while making the implementation dramatically simpler, smaller, more direct, and more inevitable in hindsight.

Do not stop at local cleanup when a clearer framing could delete whole branches, helpers, modes, conditionals, wrappers, layers, or concepts.

## Workflow

1. Identify the review scope.
2. Inspect the explicit scope, PR diff, current branch diff, or current direction. If the branch is stacked, state the base/range used and why it excludes unrelated parent work.
3. Include related uncommitted local files. Exclude only files that are clearly unrelated, generated noise, or explicitly scoped out.
4. Read `.agents/CONTEXT.md`, `.agents/CONTEXT-MAP.md`, `.agents/contexts/*/CONTEXT.md`, or `.agents/adr/` when domain language, ownership, module seams, or ADR-backed decisions affect the review.
5. Classify findings by structural severity, not cosmetic preference.
6. Prefer high-conviction findings over a long list of nits.
7. For every finding, give the concrete file path, code area, why it hurts maintainability, and the smallest credible remedy.

## Onmax Skill Routing

- Use `simplify` when the main question is how to shrink scope, narrow API surface, or choose the smallest useful change set.
- Use `validate-direction` before hardening a major rewrite direction, public API change, ADR, or implementation plan.
- Use `grill-with-docs` when the review turns on project language, domain meaning, or ownership boundaries that should be captured in `.agents/`.
- Use `handoff` when the review cannot be acted on in the current session.

## Ecosystem Contract

This skill is stricter than `simplify`, but it should not replace it.

- Keep `simplify` responsible for smallest useful scope and accidental-complexity reduction.
- Keep `strict-code-review` responsible for code quality findings that may block a PR or justify a larger rewrite.
- Escalate to `validate-direction` when a proposed rewrite changes architecture, public API, migration strategy, or a durable implementation direction.
- Escalate to `grill-with-docs` when the finding depends on domain language, project vocabulary, or an ADR-worthy ownership decision.
- Return to `handoff` when the useful next move is clear but too large for the current session.

## Review Questions

- Is there a code-judo move that would delete a whole category of complexity?
- Can the change be reframed so fewer concepts, branches, helper layers, or modes are needed?
- Does the diff improve or worsen the local architecture?
- Did it add ad-hoc branching, scattered special cases, or feature checks in shared paths?
- Did a cohesive module become more coupled, more stateful, or harder to scan?
- Is the logic living in the right file, package, layer, or module?
- Did the change push a file past a healthy size boundary, especially across 1000 lines?
- Are repeated conditionals signaling a missing model, dispatcher, helper, or policy?
- Is the implementation direct and legible, or does it rely on incidental control flow?
- Is each abstraction earning its keep, or is it a thin wrapper?
- Did the diff introduce casts, optionality, nullable modes, `any`, `unknown`, or ad-hoc object shapes that obscure the real invariant?
- Is the code reusing canonical helpers, or duplicating a bespoke near-copy?
- Is the orchestration more sequential or less atomic than it needs to be?

## Flag Aggressively

- A complicated implementation where a cleaner framing could delete whole concepts.
- Refactors that move complexity around without reducing what a reader must hold in their head.
- Files crossing 1000 lines due to the change without a strong structural reason.
- New conditionals bolted onto unrelated flows.
- One-off booleans, nullable modes, feature flags, or temporary branches likely to become permanent debt.
- Feature-specific logic leaking into general-purpose modules.
- Magic handling that hides a simple data shape or invariant.
- Thin wrappers, identity helpers, or pass-through abstractions.
- Unnecessary casts, `any`, `unknown`, or optional params.
- Copy-pasted logic where a canonical helper should exist.
- Edge-case handling inserted into an already busy function.
- Logic added to the wrong layer or package.
- Sequential async flow where independent work could be clearer in parallel.
- Partial-update logic that leaves state harder to reason about.

## Preferred Remedies

- Delete a layer of indirection instead of polishing it.
- Reframe the state model so conditionals disappear.
- Move ownership so the feature becomes a natural extension of an existing module.
- Turn special-case logic into a simpler default flow.
- Extract a focused helper or pure function when it removes repeated reasoning.
- Split a large file into focused modules.
- Move feature logic behind a dedicated abstraction when that abstraction owns real behavior.
- Replace condition chains with a typed model or explicit dispatcher.
- Separate orchestration from business logic.
- Collapse duplicate branches into one clearer flow.
- Delete wrappers that do not clarify the API.
- Reuse the canonical helper instead of creating a near-duplicate.
- Make type boundaries explicit so control flow gets simpler.
- Move logic to the package, layer, or module that already owns the concept.
- Parallelize independent work when that also simplifies orchestration.
- Make related updates atomic when partial state would be harder to reason about.

## Output

```md
Strict review scope:
- ...

Blockers:
1. <finding title>. `<path>`: <code area>. <why this structurally hurts>. Remedy: <specific change>.

Strong improvements:
1. ...

Leave as-is:
- ...

Needs validation:
- ... <!-- only if a suggested rewrite needs user/product confirmation -->

Suggested next skill:
- `simplify` | `validate-direction` | `handoff` | none
```

## Approval Bar

Do not approve merely because behavior appears correct.

Treat these as presumptive blockers unless clearly justified:

- The PR preserves incidental complexity when a plausible code-judo move would delete it.
- The PR pushes a file from below 1000 lines to above 1000 lines.
- The PR adds ad-hoc branching that tangles an existing flow.
- The PR solves a local problem by scattering feature checks across shared code.
- The PR adds unnecessary abstraction, wrappers, casts, or optionality that make the design more indirect.
- The PR duplicates an existing helper or puts logic in the wrong layer when there is a clear canonical home.
