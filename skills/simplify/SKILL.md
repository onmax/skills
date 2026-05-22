---
name: simplify
description: Reviews a PR diff, explicit scope, or current direction for accidental complexity and returns the smallest useful simplification plan. Use when the user invokes `/simplify`, says simplify, says something feels too complex, asks for a smaller API surface, or wants to reduce PR/diff scope before applying changes.
---

# Simplify

## Quick Start

Use this skill to make the current work smaller without losing the point of the work.

Default posture: analyze first. Do not edit files in the first pass. Apply changes only after the user explicitly asks to make the edits.

Default scope is the current PR diff or current branch diff. If the user gives an explicit scope, use that instead: a PR URL, pasted diff, file, package, API, component, plan, or current conversation direction.

If there is no clear scope, ask one question.

## Workflow

1. Identify the simplification scope.
2. Inspect the explicit scope, PR diff, current branch diff, or current direction.
3. Read `.agents/CONTEXT.md`, `.agents/CONTEXT-MAP.md`, or `.agents/adr/` only when naming, domain language, boundaries, or ADR-backed decisions matter to the simplification.
4. Separate essential complexity from accidental complexity.
5. Choose from the smallest action set:
   - `leave as-is`
   - `rename`
   - `remove`
   - `merge`
   - `narrow`
6. Return recommendations in priority order.

`leave as-is` is a valid final answer. Do not invent simplifications when the complexity is earning its keep.

## Output

Use this shape:

```md
Simplify scope:
- ...

Keep:
- ...

Simplify:
1. `narrow` - ...
2. `merge` - ...
3. `rename` - ...

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
1. `narrow` - Limit the new option to the one caller that needs it.
2. `merge` - Collapse the duplicate helper into the existing parser path.

Do not change:
- The user-facing response shape.

Apply only if asked:
- I would start with the option narrowing because it reduces API surface without touching behavior.
```
