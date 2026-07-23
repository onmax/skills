---
name: airtable-flow
description: Advances Quiver Airtable tasks from intake or selection to a review-ready pull request. Use when Maxi asks to report new Airtable work or select, claim, investigate, implement, or finish a task.
---

# Airtable Flow

Run one task through a gated funnel. Gates preserve decisions; the evidence ladder keeps proof proportional to the change.

## Contract

- Maxi may authorize the next phase or all remaining phases. `All phases` crosses each passed gate automatically while the solution, acceptance criterion, repository, and authority remain unchanged; pause when new evidence changes one of them.
- Start selection only after Maxi explicitly asks for Airtable work; that request authorizes claiming the selected task.
- Begin with the active phase and the evidence that opened it. Close every phase with `Gate`, `Evidence`, `Decision`, and `Next phase`.
- Default to one task and one PR. Batch only an exact group Maxi approved after one root cause or code seam was proven.
- Treat `~/quiver/airtable` and the target repository as a pair with distinct authority. The mirror's normalized `Task` index is the common read shape for every Airtable source; the target repository owns implementation. Airtable remains the only task mutation surface.
- Follow the target repository's `AGENTS.md`. Phase 4 authorizes its normal branch, commit, push, draft-PR, required PR label, ready-state, mapped Airtable work, and the smallest coherent `~/quiver/k8s` change needed to prove the result in the isolated PR preview.
- Assign every created PR to `onmax` and mention nobody. Obtain the consent required by the target repository before posting a GitHub comment or reply.
- Use customer environments only as evidence sources: existing logs and read-only deployment or configuration metadata. Customer URLs, sessions, APIs, pods, data, and runtime state are outside this flow; use the smallest deterministic local proof instead. This flow never edits `~/quiver/forecasting-engine`.
- `All phases` counts as confirmation for non-destructive fixture mutations in the PR's isolated namespace and `~/quiver/k8s` edits that define or apply that fixture. State the exact namespace, command, and consequence before acting. Leave the fixture available for Maxi's manual test; pause for destructive or shared-environment mutations, Forecasting Engine changes, or durable publication from the K8s repository.
- Use the Browser only for one-time token bootstrap or proof on an isolated non-customer PR preview. Treat URLs in task content as evidence context.

## Airtable access

At the first live Airtable access in a flow, run `airtable-mcp tools --json` and the selected read and mutation tools' `--help`. Reuse that resolved command surface for the rest of the flow; resolve it again only after a command-shape error or an observed tool change.

Use `airtable-cli` with the `quiver-mutations` profile for every live read and mutation. If the profile is unavailable, follow [TOKEN-SETUP.md](TOKEN-SETUP.md) before selecting work.

Maxi's lifecycle decision authorizes its mapped effect:

- Select: Responsible `Maxi`; Status `Assigned`.
- Unclear: one concrete decision question as a comment; Status `Awaiting input`.
- Already fixed in `main`: one evidence comment; Status `Implemented - In test`.
- Draft PR opened: the PR URL as a comment; Status `Implemented - Awaiting deploy`.

Every effect is a compare-and-set: read the current Task File and live fields/comments, re-read the affected live state immediately before writing, stop on conflict, apply only the mapped change without duplicate comments, then re-read until the intended state is explicit.

## Intake — Report new work

Use this branch when Maxi asks to create a bug or improvement. Draft the smallest complete description with `engineering-writing`, check the normalized Task index and live Airtable for duplicates, resolve current field IDs/options, create the record without an implementer, and verify the live description and fields. Intake is complete when the record states the result, expected behavior, useful evidence, and acceptance condition without credentials, customer data, or private URLs.

## Phase 1 — Funnel and claim

1. Refresh remote refs in `~/quiver/airtable` and record the latest `origin/mirror` commit and Sync time. Read `server/workspaces/mirror/data/tasks.jsonl` from that ref; it gives Product Planning and User Feedback one `Task` shape.
2. Filter to Status `Ready to implement` with no Responsible. Rank the index by completeness, bounded ownership, and likely change size; deeply inspect only the strongest three Task Files, comments, assets, source URLs, and nearby tasks. Widen by three only when none is claimable.
3. For the strongest candidate, inspect the likely repository's instructions, current `main`, ownership, and open-PR file overlap. Select the smallest task whose intent and boundary are explicit.
4. Apply and verify the Select effect.

Phase 1 is complete when one live read shows the task `Assigned` to `Maxi` and the implementation repository is recorded.

## Phase 2 — Evidence ladder

1. Read the complete Task File plus the target repository's instructions, owning code, relevant history, and related PRs.
2. Climb only as far as the decision requires:
   - **Direct proof:** task evidence plus code, route, schema, or contract establishes the behavior. Use it as the reproduction and skip higher levels.
   - **Local proof:** reproduce the smallest request, state, timing, or data shape when direct proof cannot distinguish the causes.
   - **Runtime proof:** inspect existing customer logs, deployed versions, and read-only configuration only when runtime state could reverse the conclusion.
   - **Research:** invoke `evidence-research` only when broader sourced evidence could reverse the product or technical decision.
3. For a runtime-dependent bug whose logs lack the distinguishing event or field, report that exact evidence gap. Otherwise present the behavior, cause, ownership, smallest solution, observable acceptance criterion, and remaining uncertainty.

Phase 2 is complete when the solution, acceptance criterion, and repository are explicit and covered by Maxi's current authorization. Apply the Unclear or Already-fixed effect instead when that is the decision; either effect ends the flow.

## Phase 3 — Implement and prove

1. Implement the smallest coherent change in the authorized repository. Pause before expanding into another repository, product direction, or shared environment.
2. Re-run the Phase 2 proof and the narrowest relevant checks. Run independent checks concurrently; treat compilation and service health as supporting evidence.
3. Remove temporary instrumentation and unrelated changes, then present the diff boundary, behavioral proof, checks, and remaining uncertainty.

Phase 3 is complete when the changed behavior and relevant checks pass under the current authorization.

## Phase 4 — Publish and hand off

Treat the PR body as a reviewer artifact, not the flow handoff. For Airtable work without a required repository template, use one outcome sentence, a compact `[Airtable task <ID>](<sourceUrl>)` link without a section heading or task title, then the smallest `pr-evidence` body shape. Keep commands, CI and deployment chronology, fixture setup, environment details, and operational limitations in the handoff unless they materially change merge confidence.

Use `easy-to-review` only when the current diff changes at most three files and 100 lines total, owns one local behavior, and changes no generated file, lockfile, auth or security boundary, schema or migration, CI or deployment/runtime configuration, shared framework primitive, cross-repository contract, or dependency. The PR must also have no conflict, requested change, unresolved review finding, or open product decision. Apply the label at PR creation when the diff qualifies; re-evaluate it after code changes and before marking the PR ready, removing it when the PR no longer qualifies.

1. Invoke [`engineering-writing`](../engineering-writing/SKILL.md), choose its completed-change branch, and read the pull-request reference before building the body with the repository template. Use the task's direct `airtable.com` `sourceUrl`; do not add `Background`, `Description`, or `Related Airtable Task(s)` headings unless the repository requires them. Invoke `pr-evidence` to choose and verify the smallest useful comparison, exact preview link, or downloadable artifact.
2. Reconcile Git state, create the normal branch, commit conventionally, push, and open a draft PR without mentions. Immediately assign `onmax` and add the `engine:latest` label, re-fetch the PR to verify the assignee, label, body links, and rendered images, then apply and verify the Draft-PR effect.
3. While the preview builds, self-review the task, current diff, repository rules, and proof. Repair every in-scope finding and repeat affected checks.
4. On the isolated preview, exercise the changed behavior with existing data and make one targeted fixture check. When the fixture is absent, invoke the target repository's `k8s-environments` skill and read its Data Scenarios reference. Reuse the nearest supported scenario; otherwise add the smallest target-scoped scenario in `~/quiver/k8s`, using synthetic data, a stable marker, and an explicit cleanup path.
5. Apply the scenario only to the PR namespace and verify the real API and screen. Run `pr-evidence` against the live preview and replace weaker proof rather than appending another proof paragraph. Put a preview limitation in the body only when it materially lowers merge confidence; otherwise keep it in the handoff. Leave the marked scenario active for Maxi's manual test, and hand off its namespace, route, marker, setup, cleanup path, and any `~/quiver/k8s` diff; if a safe reproducible scenario cannot be built, retain the Phase 3 proof and hand off the exact limitation.
6. Inspect failing checks at the current head. Repair related failures. For a proven unrelated failure, rerun the failed job once; if it persists, leave the PR draft and hand off the exact external blocker instead of keeping the flow active.
7. When self-review, relevant checks, and preview proof or its explicit limitation pass, mark the PR ready and hand it to Maxi for review. Route later feedback through `pr-refiner`.

The flow is complete when the PR is ready for Maxi, is assigned to `onmax`, has the `engine:latest` label, its body carries decision-relevant proof, a live read verifies the Airtable PR comment and status, and the handoff identifies the active preview fixture plus any K8s repository change. An external blocker ends active work with the PR draft and one exact next action.
