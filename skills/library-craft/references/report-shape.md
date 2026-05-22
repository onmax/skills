# Report Shape

Write aggressive, specific reports. Default to the whole library contract unless the user gave a narrower scope.

## Output Template

```md
Library craft scope:
- <package/library and whether scope was whole-contract or user-scoped>

Keep:
- <only the patterns worth preserving>

Fix:
1. `<label>` - <direct finding>. `<absolute path>`: <specific change>. Public impact: <none|minor|breaking>. Check: <test/build/type/doc check>.
2. `<label>` - <direct finding>. `<absolute path>`: <specific change>. Public impact: <none|minor|breaking>. Check: <test/build/type/doc check>.

Breaking changes:
- <what breaks, why it is worth it, migration path, shim decision>

Context/language:
- <terms that should be captured or revisited through grill-with-docs, if any>

Ecosystem comparison:
- <whether comparison is needed, recommended subagents, or key comparable pressure>

Do not change:
- <good constraints, compatibility choices, or local conventions to preserve>
```

## Recommendation Quality Bar

Every recommendation needs:

- action label
- exact file path
- specific change
- public impact
- verification check
- reason tied to library craft, not personal taste

Avoid vague findings like "clean up utils" or "improve naming." Say which name, why it is misleading, and what concept should replace it.

## Label Meanings

- `keep` - preserve a pattern that is earning its cost.
- `rename` - a name hides the concept or leaks implementation.
- `move` - file or folder placement fights the scan path.
- `narrow` - public surface or options are broader than needed.
- `split` - one entrypoint or file owns multiple public concepts.
- `merge` - separation creates ceremony without a real concept.
- `comment` - comments are missing, stale, noisy, or API-significant.
- `test` - contract, fixture, type, or example coverage is missing.
- `break` - compatibility is making the package worse.

## Breaking Recommendation Shape

Use `break` when compatibility preserves the wrong model.

```md
`break` - <old contract> keeps callers thinking <wrong model>.
`<absolute path>`: remove/rename/narrow <specific public surface>.
Public impact: breaking.
Migration: <old import/option/behavior> -> <new import/option/behavior>.
Shim: <none|temporary deprecation shim|compat flag>, because <reason>.
Check: <test/docs/build command>.
```

Do not hide a real break behind softer wording. If it breaks imports, types, runtime behavior, defaults, documented examples, or generated output, call it breaking.

## Implementation Handoff

If the user asks to implement after the report, convert recommendations into a small edit plan:

1. public surface changes
2. internal moves/renames
3. tests and fixtures
4. docs and migration notes
5. verification commands

Do not implement during analysis-only use.
