---
name: code-review
description: Reviews a diff against repository standards, the requested behavior, and structural code quality. Use when the user asks to review a branch, PR, commit range, or work in progress, including strict review.
---

# Code Review

Review the smallest correct diff and report only actionable findings. Read-only review does not authorize edits, comments, pushes, or GitHub mutations.

## Scope

Resolve the fixed point from the user's range, the PR base, or the merge-base with the default branch. Verify the ref and capture both the diff and commit list. If the repository has unrelated dirty changes, separate them from the review range.

Find the originating request from the user, PR, issue, spec, or commit history. Find repository standards in `AGENTS.md`, contribution docs, nearby code, and tests. If no spec exists, say so and still review observable correctness and scope.

## Review Axes

1. **Behavior:** correctness, missing requirements, regressions, error handling, security, and unsupported assumptions.
2. **Scope:** unrequested behavior, speculative generality, unnecessary compatibility layers, and changes that belong upstream or in another slice.
3. **Structure:** duplication, unclear ownership, shallow wrappers, scattered changes, leaky seams, confusing names, and unnecessary indirection.
4. **Standards:** repository conventions that tooling does not already enforce.
5. **Proof:** whether tests and runtime evidence cover the changed behavior, including failure paths.

When a diff crosses configuration forms, generated/runtime/consumer representations, providers, frameworks, output modes, or resource lifecycles, load [contract-coverage.md](references/contract-coverage.md) and report every uncovered affected cell.

For `strict` review, load [strict.md](references/strict.md) and apply its deeper invariants and maintainability pass. Treat heuristics as judgment calls; repository rules and demonstrated behavior win.

## Method

Inspect context around each changed hunk before judging it. Trace data and control flow far enough to prove the consequence. Run read-only or non-mutating checks when they materially validate a finding. Do not report style nits, hypothetical risks without a reachable mechanism, or issues outside the diff unless the change directly exposes them.

Order findings by severity. Each finding must name the file and line, explain the concrete failure mechanism and user or maintainer consequence, and propose the smallest correction. Keep Standards and Spec conclusions separate when one passes and the other fails.

If there are no actionable findings, say so and state the remaining verification gap.
