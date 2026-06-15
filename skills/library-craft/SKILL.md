---
name: library-craft
description: "Reviews reusable package craft: exports, layout, naming, tests, docs, compatibility, and release shape. Use for npm packages, SDKs, framework utilities, reusable modules, or public APIs."
---

# Library Craft

## Quick Start

Use this skill when the work affects a reusable package, public API, package exports, or maintainer-facing source organization.

Example trigger: `library-craft this package before we publish`

Default posture: analysis first. Do not edit source files unless the user explicitly asks to implement.

Default scope: review the whole library contract unless the user gives a narrower scope.

Breaking changes are welcome when they make the library cleaner, smaller, or more honest. If the user opts out of breaking changes, preserve compatibility and name the trade-off.

## Workflow

1. Identify the package, public entrypoints, consumer contract, and whether breaking changes are allowed.
2. Read package metadata, export maps, source entrypoints, build config, tests, fixtures, README/docs, examples, and release notes.
3. Separate the public surface from internal shape.
4. Review the craft lenses:
   - `surface` - exports, subpaths, types, defaults, runtime guarantees.
   - `shape` - folders, helpers, generated files, fixtures, build output.
   - `names` - user-facing concepts, options, files, helpers.
   - `tests` - public API, fixtures, examples, type tests, regression checks.
   - `comments` - public docs, rationale, compatibility notes, noisy narration.
   - `release` - semver impact, migration path, shims, deprecations.
5. Load [references/principles.md](references/principles.md) for the review vocabulary.
6. For serious public-surface decisions, recommend focused ecosystem comparison. Load [references/ecosystem-comparison.md](references/ecosystem-comparison.md) before proposing large API, export, compatibility, or release-shape changes.
7. Load [references/report-shape.md](references/report-shape.md) before writing the final aggressive report.

## Action Labels

- `keep` - preserve a pattern that is earning its cost.
- `rename` - a name hides the concept or leaks implementation.
- `move` - file or folder placement fights the scan path.
- `narrow` - public surface or options are broader than needed.
- `split` - one entrypoint or file owns multiple public concepts.
- `merge` - separation creates ceremony without a real concept.
- `comment` - comments are missing, stale, noisy, or API-significant.
- `test` - contract, fixture, type, or example coverage is missing.
- `break` - compatibility is making the package worse.

For every `break`, include what breaks, why it is worth it, the migration path, and whether a compatibility shim should exist.

## Rules

- Keep `keep` short; spend most of the report on pressure.
- Treat `package.json` exports, README examples, and generated types as API.
- Comments explain why; they do not narrate what the code already says.
- Do not invent a new taxonomy when the package already has a clear local pattern.
- If the issue is really module depth, seam design, or locality, hand off to `improve-codebase-architecture`.
- If naming changes affect project language, say so and suggest `grill-with-docs`; do not update project context by default.
- Do not publish comments, issues, releases, or PR notes without explicit user consent.
