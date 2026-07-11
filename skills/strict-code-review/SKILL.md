---
name: strict-code-review
description: Reviews code for maintainability, structure, abstractions, large files, and cleanup opportunities. Use when the user asks for strict, harsh, deep, or ambitious code review.
---

# Strict Code Review

Use this skill for a strict review focused on implementation quality, maintainability, abstraction quality, and codebase health.

Default posture: findings first and read-only. Edit files or mutate PR state only when the user explicitly asks for that follow-up.

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

## Review Lenses

- Framing: find code-judo moves that delete concepts, branches, helpers, modes, or special cases instead of relocating complexity.
- Architecture and ownership: check coupling, module seams, shared-path feature leakage, and whether the logic lives in its canonical file, package, or layer.
- Control flow and state: expose incidental sequencing, repeated conditionals, nullable modes, partial updates, and hidden invariants; prefer a direct state model or explicit dispatcher.
- Abstractions: remove thin wrappers and pass-through helpers; introduce a focused helper or owned abstraction only when it removes repeated reasoning or owns real behavior.
- Types and duplication: flag unnecessary casts, `any`, `unknown`, optionality, ad-hoc shapes, and bespoke copies of canonical helpers.
- Cohesion and scale: check whether the change makes a file or module harder to scan, especially when it pushes a file across 1000 lines; split only along a real responsibility boundary.
- Orchestration: separate business logic from coordination, run independent work in parallel when clearer, and keep related state updates atomic.

## Skill Boundaries

- Use `simplify` for the smallest useful scope, narrower API surface, and accidental-complexity reduction. Use this skill for structural code-quality findings that may block a PR or justify a larger rewrite.
- Use `validate-direction` before hardening a rewrite that changes architecture, public API, migration strategy, an ADR, or a durable implementation direction.
- Use `handoff` when the useful next move is clear but too large for the current session.
- Create durable project documentation only when the user explicitly requests capture.

## Blocker Bar

Correct behavior alone does not clear the review. Treat a high-conviction finding as a presumptive blocker when a credible scoped remedy exists and the change:

- preserves incidental complexity that a plausible code-judo move would delete;
- pushes a file from below 1000 lines to above 1000 without a strong structural reason;
- tangles shared flow with ad-hoc branching, scattered feature checks, or logic in the wrong layer;
- adds unnecessary wrappers, casts, optionality, nullable modes, or duplicate helpers that obscure the design.

Put structural improvements below this bar in `Strong improvements`, not `Blockers`.

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
