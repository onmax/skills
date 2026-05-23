# Ecosystem Comparison

Use ecosystem comparison when a recommendation would affect public API, export shape, runtime adapters, compatibility, release posture, or major package organization.

The goal is to extract pressure from comparable libraries, not copy their structure.

## When To Recommend It

Recommend focused comparison when:

- the public surface is unclear or likely to break consumers
- the package has runtime or framework adapters
- naming would define a long-lived mental model
- compatibility shims are blocking a cleaner shape
- tests need realistic fixtures or type/API snapshots
- release posture is uncertain
- the package belongs to a known ecosystem with strong conventions

Do not block small local cleanup on research.

## How To Scope It

Pick comparable libraries that solve the same kind of contract problem:

- same runtime class
- same framework or plugin host
- same package-manager/module-resolution constraints
- same API shape
- same adapter family
- same release or migration pressure

Ask subagents to compare one focused slice each. Useful slices:

- public exports and package metadata
- source layout and internal boundaries
- naming and option vocabulary
- tests, fixtures, examples, and generated-output checks
- comments, compatibility shims, deprecations, and migration docs
- release shape and breaking-change posture

## Subagent Prompt Shape

```md
Research comparable library craft for <target package>.

Target project root: <absolute path>
Target question: <public surface / naming / adapter / compatibility / tests / release issue>
Comparable source area: <ecosystem or libraries>
Report path: <os-temp-dir>/evidence-research/<project>/<topic>/reports/<slice>.md

Do not mutate the project repo.
Compare patterns, trade-offs, and migration posture.
Return only generalized pressure that applies to this package.
Include source links when useful.
```

## What To Extract

Extract:

- vocabulary users already expect
- import paths that feel stable
- what is public versus internal
- where runtime edges live
- how adapters are named and grouped
- how examples teach first use
- how tests protect the contract
- how compatibility is deprecated or broken
- what migration wording would be honest

Avoid:

- copying folder names without the same problem
- treating popularity as proof
- importing another ecosystem's accidental complexity
- recommending a pattern that the target package cannot maintain

## Synthesis Rule

Use ecosystem findings as decision pressure:

```md
Comparable pressure:
- Similar libraries usually hide <volatile detail> behind <public concept>.
- This package currently exposes <detail>, which creates <cost>.
- Recommendation: <action label> because <reason>.
```

If evidence conflicts, name the trade-off instead of forcing consensus.
