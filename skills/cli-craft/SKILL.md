---
name: cli-craft
description: Builds and evolves command-line interfaces around an explicit CLI contract, including arguments, automation-safe output, exit behavior, interaction, mutation boundaries, and executable proof. Use when creating a CLI, adding or changing commands and flags, or changing documented CLI output.
---

# CLI Craft

Treat each command as a public **CLI contract**: inputs, streams, status, effects, and unattended behavior are one boundary.

## Workflow

1. **Inspect the surface.** Read the applicable instructions, actual executable entrypoint, command and option definitions, package wiring, help, docs, tests, and existing automation consumers. Identify the authorized slice and compatibility expectations. This step is complete when every public entrypoint and existing contract affected by the change is accounted for.

2. **State the slice contract.** Define commands, positionals, flags, defaults, stable stdout, stderr diagnostics, success and failure statuses, interactive behavior, configuration sources, secret sources, mutation scope, and observable resulting state. This step is complete when every user-visible input and outcome in scope has one meaning.

3. **Choose the smallest coherent shape.** Follow repository conventions and let present pressure earn dependencies, parser frameworks, command registries, and configuration systems. Keep process concerns at a thin edge over callable domain work when multiple formats, reuse, testing, or cleanup makes that seam useful. This step is complete when every added layer answers a current contract need.

4. **Implement the authorized slice.** Keep documented automation output payload-only, route diagnostics separately, preserve a complete non-interactive path, source secrets through protected channels, and make mutation intent proportional to consequence. This step is complete when the command can fulfill the stated contract without hidden terminal or ambient-state requirements.

5. **Prove the real entrypoint.** Invoke the actual command through its normal local or installed path. Exercise the happy path and a meaningful failure or alternate state; assert stdout, stderr, exit status, unattended behavior, and the relevant side effect or resulting state. This step is complete when exact commands demonstrate the external contract, rather than only imported internals.

6. **Preserve runnable truth.** Update generated help, usage examples, docs, and compatibility notes that users or agents rely on, then rerun existing contract tests. This step is complete when a new caller can perform the principal operation from the documented example and the final report includes the exact proof invocations.

## Conditional reference

Load [REFERENCE.md](REFERENCE.md) before choosing an output mode, adding prompts or risky mutation, introducing parser or configuration machinery, packaging an executable, or changing an established CLI contract. Apply only the sections whose pressure exists.

## Boundaries

- Use `library-craft` for a whole-package public API or release-shape review.
- Use `diagnosing-bugs` when the task is to find the cause of broken CLI behavior.
- Use `evidence-research` when an ecosystem or framework decision could change the contract.
- Publication, releases, remote actions, and destructive effects retain their own explicit user-authority boundaries.
