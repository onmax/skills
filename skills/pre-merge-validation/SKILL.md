---
name: pre-merge-validation
description: Proves merge-ready PR behavior with consumer-install or runtime validation evidence. Use before merging package, provider, generated-output, runtime, or docs-as-contract changes.
---

# Pre-Merge Validation

## Quick Start

Use this skill as the final evidence gate before merging a consumer-facing PR.

Default posture: remote, adaptive, and evidence-only. Run through `vps-connection`, prove one primary real consumer scenario, write a ledger result keyed by PR and head SHA, and hand confirmed PR defects to `pr-refiner`.

This skill does not merge, approve, comment on PRs, edit PR bodies, push branches, or mutate source code by default.

## Trigger From PR Coordination

`pr-stack-coordinator` should call this skill before merge when a PR changes public package behavior, exports, docs-as-contract, examples, runtime integration, generated output, provider wiring, or any area with recent post-merge consumer defects.

Skip with a concrete reason for docs-only, ADR-only, lint-only, dead-code-only, or purely internal PRs already proven by repository-local checks that match consumer usage.

## Workflow

1. Resolve the PR number, repository, base branch, head branch, and exact head SHA.
2. Inspect PR evidence: title, body, changed files, checks, comments or bot output that may include `pkg.pr.new`, package manifests, docs, examples, playgrounds, and prior validation ledger entries.
3. If a passing ledger entry exists for the same PR and head SHA, return `pass` without rerunning unless the user asks for a fresh run.
4. Decide whether the gate is required, skipped, stale, or blocked.
5. Use `vps-connection` to run validation remotely. Prefer discovered helpers such as `codexh` or direct `ssh` patterns from that skill.
6. Create a fresh per-run workspace under the remote Validation Scaffold Root.
7. Search first, invent second: seed the Dynamic Consumer Repro from existing repros, examples, docs, playgrounds, or scaffold seeds before inventing a new scenario.
8. Install the Validation Artifact in priority order: `pkg.pr.new`, `pnpm pack`, local workspace path install, then git dependency.
9. Run the smallest credible consumer proof, usually `pnpm install` plus one targeted `typecheck`, `build`, `verify`, `test`, or runtime script.
10. Classify failures as invalid repro, real PR defect, or infrastructure block.
11. Write the Validation Ledger and preserve useful repro artifacts.
12. Return the verdict and concise evidence summary to the caller.

## Dynamic Consumer Repro Rules

- Prove one primary consumer scenario by default.
- Keep the repro minimal but real enough to catch package installation, exports, peer dependencies, generated files, framework hooks, and runtime startup issues.
- Prefer package-manager behavior a real consumer would hit over monorepo workspace shortcuts.
- Do not build a provider, framework, browser, or deployment matrix unless the PR risk is specifically compatibility across those surfaces.
- If a generated repro is useful beyond this run, promote it to a scaffold seed. Recommend a repo fixture only when it proves a recurring invariant worth versioning.

## Verdicts

- `pass`: current PR head SHA passed the consumer validation.
- `fail-pr`: the repro is valid and exposed a real PR defect; hand off to `pr-refiner`.
- `fail-repro`: the attempted repro is invalid or underspecified; refine it or ask one blocking question.
- `stale`: prior passing evidence exists, but the PR head SHA changed.
- `skip`: no meaningful consumer-install risk; include the reason.
- `blocked`: validation cannot run because remote access, artifact publishing, credentials, or dependency infrastructure is unavailable.

`pr-stack-coordinator` may proceed only on `pass` or a justified `skip`. `stale`, `fail-pr`, `fail-repro`, and `blocked` stop the merge plan.

## Guardrails

- Never post PR or issue comments without explicit user consent.
- Never treat this skill as CI replacement; it complements repository-local checks.
- Never mutate the target PR branch by default. Fix only the validation repro and runner artifacts.
- Keep remote output compact and redact secrets, following `vps-connection`.
- Tie all passing evidence to the exact PR head SHA.
- If the user asks to fix a confirmed PR defect, route to `pr-refiner`.

## Reference

Use [REFERENCE.md](REFERENCE.md) for remote path conventions, ledger shape, artifact selection, and command examples.
