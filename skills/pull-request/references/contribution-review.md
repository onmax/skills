---
name: upstream-pr-review
description: Reviews one upstream contribution for justification, scope, and implementation quality before handing it to maintainers.
---

# Upstream PR Review

Decide whether one upstream pull request is justified, minimal, and ready for maintainer attention. Review from the receiving maintainer's perspective without inventing product decisions or cleanup work.

This reference owns the contribution-fit pass. The pull-request router owns feedback, CI failures, and merge-readiness convergence.

Example: `Use pull-request on <PR URL>. Review it as an upstream contribution, fix concrete findings, and update the existing branch, but only propose PR-body wording.`

## Mutation Contract

- A bare invocation or `review`, `audit`, `check`, or `status` request is read-only.
- `fix`, `apply`, `improve`, or `clean up` authorizes scoped code edits and relevant checks. Commit or push only when the user also asks to update or converge the existing PR and branch ownership is clear.
- Apply the consent contract in [`../SKILL.md`](../SKILL.md) to GitHub and history mutations.
- Never create a duplicate PR when the contribution already has an owned branch.

## Review

1. Resolve one PR or branch and pin its base merge-base, head, commit list, changed files, local changes, and the diff that belongs only to this contribution. Stop if a stack or uncertain worktree ownership makes the range ambiguous.
2. Establish the contribution contract from the PR body, linked issue or discussion, repository instructions, and nearby code history. Inspect blame or the commits that introduced the affected seam when they could explain an invariant or rejected approach.
3. Classify the change:
   - `confirmed bug`: reproduce the symptom or identify the failing proof, trace the root cause, and show why the chosen seam fixes every relevant caller.
   - `discussed feature`: cite the exact issue, discussion, spec, or maintainer statement that establishes the direction and scope.
   - `undiscussed feature`: treat the direction as a proposal. Do not convert assumptions into requirements or expand the implementation to make it look settled.
4. Run the same pinned diff through these lenses before editing:
   - `code-review`: repository Standards and the contribution contract as the Spec. Pass the fixed point and spec directly; do not configure the upstream repository solely to run the review.
   - `ponytail:ponytail` at `full`: necessity, reuse, native or existing primitives, root-cause placement, and the shortest correct diff.
   - a scope pass: accidental complexity, concrete reductions, and the irreducible remainder.
   The Ponytail plugin is required. If it is unavailable, report the missing lens instead of imitating it or calling the audit complete.
5. Keep the lens reports independent until all are complete, then deduplicate overlapping findings. Repository requirements, correctness, security, accessibility, and trust-boundary validation outrank line-count reductions.
6. Choose one verdict:
   - `ready`: the direction is supported and no actionable finding remains.
   - `ready after fixes`: the direction is supported and only concrete, in-scope corrections remain.
   - `needs upstream discussion`: feature direction or scope lacks durable agreement.
   - `not justified`: the evidence does not support carrying the change.
7. For `needs upstream discussion`, use `engineering-writing` to draft a short PR-body note that separates confirmed behavior from the open decision. Do not edit the body without consent.
8. When mutation is authorized, apply only actionable findings that preserve the established contract, run the narrow proof, and rerun the affected review lenses on the final diff. A clean `leave as-is` result is complete; never manufacture a cleanup commit.

Use `validate-direction` when resolving an open product or API choice would otherwise harden a new direction.

## Output

```md
Verdict: <ready | ready after fixes | needs upstream discussion | not justified>

Contribution contract:
- Type: <confirmed bug | discussed feature | undiscussed feature>
- Evidence: ...
- Diff: <base...head>

Findings:
- Direction: ...
- Standards: ...
- Spec: ...
- Ponytail: ...
- Scope: ...

Applied: ...
Proposed PR-body note: ...
Needs consent: ...
```

Omit empty rows. Cite exact paths, hunks, commits, issues, discussions, or tests for every actionable finding.
