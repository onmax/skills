# Library Craft Principles

Use these ideas as operating language, not as decoration. Prefer plain recommendations grounded in the current package.

## Public Surface

The public surface is every path a consumer can depend on: root exports, subpath exports, types, CLI bins, generated declarations, README examples, documented options, and runtime guarantees.

Review it as a contract. A package should not expose internal file structure, helper names, compatibility hacks, runtime probes, or build artifacts just because they exist.

Ask:

- What decisions are callers forced to know?
- Which exports exist only because internals leaked?
- Which imports should be impossible, private, or deliberately named as unstable?
- Does the README teach the same surface that the package actually exports?

## Information Hiding

Hide volatile decisions behind a smaller public surface. The package should be able to change internals, adapters, file layout, and build tools without making consumers relearn the model.

Favor explicit entrypoints over accidental reachability. If callers need a capability, name it. If they do not, keep it internal.

## Conceptual Integrity

A library should feel like one coherent model. Names, folders, exports, docs, tests, and examples should repeat the same concepts.

Prefer domain nouns and user-facing capabilities over implementation trivia. A name that only makes sense after reading the implementation is not doing enough work.

## Essential Complexity

Preserve complexity that belongs to the problem. Remove complexity caused by old compatibility, accidental exports, duplicated configuration, over-broad options, or folder splits that do not map to a user or maintainer concept.

Do not optimize for fewer files or fewer lines. Optimize for fewer concepts a caller or maintainer must hold at once.

## Deep Interfaces

Prefer small interfaces that carry meaningful behavior. A broad option bag, many equivalent entrypoints, or pass-through helpers usually mean the package is making callers assemble the real abstraction themselves.

Ask:

- What is the smallest useful import path?
- Which options could become defaults, presets, or separate adapters?
- Which helpers are only public because tests or internals needed them?

## Discoverability Path

A maintainer should be able to scan from package metadata to public entrypoint to implementation to tests without guessing.

Good scan paths usually align:

- package name
- export map
- source entrypoint
- feature folder or internal module
- docs/example
- contract test or fixture

When a package has many public units, prefer structure that can be indexed mechanically. A new feature should become discoverable by adding the right files, not by remembering scattered registries.

## Runtime Edges

Keep runtime-specific code at the edge. Node, browser, workers, filesystem, process, bundlers, package managers, and framework hosts should appear behind named adapters or runtime boundaries.

Do not let runtime detection leak through the public surface unless runtime choice is the product.

## Compatibility Debt

Compatibility is useful when it buys trust or migration time. It becomes debt when it preserves a misleading model, blocks simpler names, forces weak types, or keeps dead runtime behavior alive.

Breaking changes are a design tool. Use them when the old contract is dishonest or too expensive to keep. Every break needs a migration path.

## Contract Tests

Tests should defend the public contract, not only the implementation branches. For libraries, contract tests include API snapshots, export-map checks, type tests, fixture projects, generated-output snapshots, CLI output, examples, and migration behavior.

Use mocks for small internals. Use realistic fixtures when behavior depends on package managers, module resolution, runtimes, generated files, or framework hosts.

## Comments

Comments are part of library craft.

Keep comments that explain API guarantees, defaults, examples, runtime quirks, spec behavior, security rationale, compatibility, deprecation, or migration intent.

Remove comments that restate names, narrate obvious code, or preserve stale reasoning. Add comments only where a future maintainer would likely misread the decision.

Influences: information hiding, conceptual integrity, essential versus accidental complexity, deep modules, simple versus easy, ubiquitous language, semantic versioning.
