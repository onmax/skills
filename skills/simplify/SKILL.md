---
name: simplify
description: Finds accidental complexity and returns the smallest useful simplification plan. Use when the user says simplify, says scope feels too complex, or wants a smaller PR, API, or direction.
---

# Simplify

## Quick Start

Use this skill to make the current work smaller without losing the point of the work.

Default posture: analyze first. Do not edit files in the first pass. Apply changes only after the user explicitly asks to make the edits.

Default scope is the current PR diff or current branch diff, including related uncommitted local changes. If the user gives an explicit scope, use that instead: a PR URL, pasted diff, file, package, API, component, plan, or current conversation direction.

If there is no clear scope, ask one question.

## Workflow

1. Identify the simplification scope.
2. Inspect the explicit scope, PR diff, current branch diff, or current direction.
3. Include related uncommitted local files and say they are in scope. Exclude only clearly unrelated files, generated noise, or files the user scoped out, and state the reason.
4. Read `.agents/CONTEXT.md`, `.agents/CONTEXT-MAP.md`, or `.agents/adr/` only when naming, domain language, boundaries, or ADR-backed decisions matter to the simplification.
5. Separate essential complexity from accidental complexity.
6. Choose from the smallest action set:
   - `leave as-is`
   - `rename`
   - `remove`
   - `merge`
   - `narrow`
   - `reframe`
7. Explain why each recommendation reduces accidental complexity. For code, name the exact path and function, component, option, type, or block to change; pair it with the explicit change.
8. If the simplification changes public API, test philosophy, PR scope, domain language, or ADR-backed direction, recommend `validate-direction` before applying edits.
9. Prove the remainder. Account for every survivor under one primary reason: `required`, `derived elsewhere`, `externally constrained`, or `deliberately deferred`. A survivor is any in-scope concept, change, behavior, or constraint left after the recommendations.
10. Return the recommendations in priority order and show the irreducible remainder.

`leave as-is` is a valid final answer. Do not invent simplifications when the complexity is earning its keep.

## Output

```md
Simplify scope:
- ...

Simplify:
1. `narrow` - <why this helps>. `<path>`: <specific code change>
2. `merge` - <why this helps>. `<path>`: <specific code change>
3. `rename` - <why this helps>. `<path>`: <specific code change>

Irreducible remainder:
- `leave as-is` - <survivor>. `<required | derived elsewhere | externally constrained | deliberately deferred>`: <reason>

Risks:
- ... <!-- only if real -->

Apply only if asked:
- ...
```

Keep only the rows and sections that apply.

## Rules

- Preserve behavior, domain meaning, and user intent.
- Prefer fewer concepts over fewer lines.
- Use `strict-code-review` when the simplification question turns into a strict maintainability review, structural quality audit, or ambitious rewrite critique.
- Do not do evidence research from this skill.
- Do not write ADRs, project docs, commits, or PR comments from the analysis pass.
- Do not broaden into architecture review or issue breakdown.
- If `.agents` docs would matter but are missing, say confidence is lower.
- If the user asks to apply a simplification, make the smallest reviewable edit first.
