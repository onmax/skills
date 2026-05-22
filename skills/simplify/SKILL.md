---
name: simplify
description: Reviews a PR diff, explicit scope, or current direction for accidental complexity and returns the smallest useful simplification plan. Use when the user invokes `/simplify`, says simplify, says something feels too complex, asks for a smaller API surface, or wants to reduce PR/diff scope before applying changes.
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
3. Include uncommitted local files when they are likely related to the PR, branch, or explicit scope. Exclude only files that are clearly unrelated, generated noise, or explicitly scoped out by the user.
4. Read `.agents/CONTEXT.md`, `.agents/CONTEXT-MAP.md`, or `.agents/adr/` only when naming, domain language, boundaries, or ADR-backed decisions matter to the simplification.
5. Separate essential complexity from accidental complexity.
6. Choose from the smallest action set:
   - `leave as-is`
   - `rename`
   - `remove`
   - `merge`
   - `narrow`
7. Explain why each recommendation reduces accidental complexity.
8. For code scopes, tie every recommendation to concrete file paths and explicit code changes.
9. Return recommendations in priority order.

`leave as-is` is a valid final answer. Do not invent simplifications when the complexity is earning its keep.

## Output

```md
Simplify scope:
- ...

Keep:
- ...

Simplify:
1. `narrow` - <why this helps>. `<path>`: <specific code change>
2. `merge` - <why this helps>. `<path>`: <specific code change>
3. `rename` - <why this helps>. `<path>`: <specific code change>

Do not change:
- ...

Risks:
- ... <!-- only if real -->

Apply only if asked:
- ...
```

## Rules

- Preserve behavior, domain meaning, and user intent.
- Prefer fewer concepts over fewer lines.
- Do not do ecosystem research from this skill.
- Do not write ADRs, project docs, commits, or PR comments from the analysis pass.
- Do not broaden into architecture review or issue breakdown.
- If related local changes are present, say they are included in the simplification scope.
- If excluding local changes, explain why they are unrelated or noisy.
- For code recommendations, include exact paths and name the function, component, option, type, or block to change.
- Do not give path-only instructions. Pair the code change with the reason it makes the work smaller or clearer.
- If `.agents` docs would matter but are missing, say confidence is lower.
- If the user asks to apply a simplification, make the smallest reviewable edit first.

## Example

User:

> /simplify this PR

Assistant:

```md
Simplify scope:
- Current PR diff.

Keep:
- The public behavior and existing domain terms.

Simplify:
1. `narrow` - Keeps the public API from growing for one caller. `src/options.ts`: keep the new option private to `createPreviewServer` instead of adding it to the public config type.
2. `merge` - Removes a second parsing path with the same responsibility. `src/parser.ts`: fold `parsePreviewInput` into the existing `parseInput` path and delete the duplicate branch.

Do not change:
- The user-facing response shape.

Apply only if asked:
- I would start with the option narrowing because it reduces API surface without touching behavior.
```
