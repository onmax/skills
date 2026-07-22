---
name: airtable-flow
description: Reports or advances Quiver Airtable tasks through a gated intake-to-review lifecycle. Use when Maxi asks to report, pick, claim, investigate, implement, or finish Airtable work.
---

# Airtable Flow

Advance one task or explicit batch through four linear phases. The **gate** is the invariant: run only the current phase, apply its predefined Airtable effects, report completion evidence, and wait for Maxi's next lifecycle decision.

## Contract

- Start Phase 1 only after Maxi explicitly asks to select Airtable work. That request authorizes selecting and claiming the recommended task without a second confirmation.
- Begin each turn by naming the active phase and the evidence that the previous gate passed. End each phase with `Gate`, `Evidence`, `Decision`, and `Next phase`.
- Default to one ticket and one PR. Batch only tasks proven to share one root cause or code seam, after Maxi approves the exact group.
- Use `~/quiver/airtable` as the primary read, search, asset, and history surface. Use live Airtable reads through `airtable-cli` only to establish a mutation precondition and verify its result. Airtable remains the mutation surface; keep the Task Mirror read-only.
- Follow the target repository's `AGENTS.md`. Starting Phase 4 authorizes normal branch, commit, push, draft-PR work, and the corresponding Airtable PR-link effect under those rules.
- Leave GitHub assignees empty and mention nobody. Obtain the consent required by the target repository before any GitHub comment or reply, and request review only from a person Maxi has named or approved.
- Treat customer environments as log-only evidence sources. Inspect existing logs plus read-only deployment and configuration metadata through the CLI when relevant, but never open a customer URL, authenticate as a customer, use a customer browser session, call customer APIs, shell into customer pods, or mutate customer data or runtime state. This flow never edits `~/quiver/k8s` or `~/quiver/forecasting-engine`.
- Invoke `airtable-cli` for every live Airtable read and mutation. Run `airtable-mcp tools --json` and the selected tool's `--help` before relying on its current name or arguments; the vendor command surface is dynamic.
- Use the explicit `quiver-mutations` CLI profile. If it is unavailable, follow [TOKEN-SETUP.md](TOKEN-SETUP.md) before selecting work; this one-time setup is a capability gate, not an Airtable mutation approval.
- Never open an Airtable task page in the Browser. Browser use is limited to the one-time token bootstrap and Phase 4 proof on an isolated non-customer PR preview, and never to reproduce a task in a customer environment.
- A customer URL in the task description, comments, or logs is evidence context, not permission to open it. It is distinct from the Task File's Airtable `sourceUrl`; never ask Maxi to sign in to the customer URL.

## Intake — Report new work

When Maxi asks to create a new Airtable bug or improvement, treat intake as a separate path rather than starting Phase 1. Use `engineering-brief` to draft the description: choose the issue-report branch for an observed failure and the implementation-request branch for a known change. Lead with the unexpected or requested result, keep only the confirmed root or ownership boundary that changes the next action, link the original report, and attach a safe screenshot only when it establishes the result faster than text.

Check the Task Mirror and live Airtable for duplicates before creating anything. Resolve current field IDs and select options through `airtable-cli`, create the smallest complete record without assigning an implementer, then re-read its live fields and description. Intake is complete when the verified record gives an engineer the result, expected behavior, useful evidence, and acceptance condition without exposing credentials, customer data, private URLs, or investigation-log detail.

## Airtable decision effects

Maxi's lifecycle decision authorizes its mapped Airtable effect. Do not ask for separate mutation approval or ask him to run the mutation. Apply the effect automatically, then report the exact live result:

- Start Phase 1 or select a task: Responsible `Maxi`; Status `Assigned`.
- Decide that the task is unclear: one concrete decision question as a comment; Status `Awaiting input`.
- Decide that the task is already fixed in `main`: one evidence comment; Status `Implemented - In test`.
- Successfully open the task's draft PR: the PR URL as a comment; Status `Implemented - Awaiting deploy`.

Before applying an effect, prove the candidate state from a current Task File and fetch the live fields and relevant comments with `airtable-mcp` under the `quiver-mutations` profile. Re-fetch the affected state immediately before writing; stop on a conflicting change rather than overwriting it. Apply only the mapped fields or comment, avoid duplicate comments, then re-fetch and verify the live values. Stop and report only when credentials, permissions, live state, or the decision itself are insufficient or ambiguous.

## Phase 1 — Select and claim

1. Refresh remote refs in `~/quiver/airtable` and name the latest `origin/mirror` commit and sync time. Read Task Files from that ref unless the checkout is proven identical; use `airtable-cli` for live record or comment reads when mirrored content is incomplete, and keep Task Assets local.
2. Consider only tasks with Status `Ready to implement` and no Responsible. Read each candidate's description, comments, assets, source URL, and nearby tasks.
3. Inspect likely code ownership, `main`, and open PRs before proposing work. Prefer the smallest task whose intent can be established confidently. Title similarity alone is not batch evidence.
4. Select the recommended task or explicit batch, immediately apply and verify the Claim effect through `airtable-cli`, then present the selection, repository, overlap findings, uncertainty, and live Airtable result.

Phase 1 is complete when a live CLI read shows every selected task `Assigned` to `Maxi` and the task-to-repository scope is recorded. Report that evidence and wait for Maxi to start Phase 2.

## Phase 2 — Investigate and align

1. Read the selected repository's agent context, relevant code and history, related PRs, and the complete Task File. Separate evidence from inference and treat each proposed cause or mechanism as falsifiable.
2. For a bug, establish the reported symptom from existing customer logs, then build the smallest deterministic local reproduction from the logged request, error, timing, or data shape and the relevant code. Do not open or log in to the customer UI to confirm it. Reach for `diagnosing-bugs` when its tight-loop discipline would improve the investigation. For an improvement, derive the current behavior from logs and code, then define an observable acceptance behavior.
3. Inspect Forecasting Engine contracts, K8s configuration, deployed versions, and existing customer logs when they can change the conclusion. Logs are the only allowed source of customer-runtime behavior; deployment and configuration metadata may support the explanation, but do not interact with customer pods, APIs, data, or UI.
4. If existing logs do not contain enough evidence to reproduce or distinguish the likely causes, report the exact missing event or field and stop at that evidence gap. Do not ask Maxi to log in, request customer credentials, or switch to an interactive customer reproduction.
5. Invoke `evidence-research` only when broader sourced evidence could reverse the product or technical decision.
6. Present the reproduced behavior, evidence, ranked causes, ownership, recommended solution, acceptance criterion, and remaining uncertainty.

If the task may be unclear or already fixed, discuss that conclusion with Maxi. When he decides, apply and verify the mapped Airtable effect automatically; that ends the flow.

Phase 2 is complete only when Maxi confirms the solution, acceptance criterion, and implementation repository. Wait for him to start Phase 3.

## Phase 3 — Implement and verify

1. Implement the smallest coherent change in the authorized repository under its local instructions. Ask before expanding into another repository, product direction, or shared environment.
2. Drive the work with the Phase 2 log-derived reproduction or acceptance behavior. Remove temporary instrumentation and unrelated changes before presenting the result.
3. Re-run the local reproduction and the narrowest relevant checks. Verification must exercise the changed behavior without a customer login or customer-state mutation; compilation or service health is supporting evidence.
4. Present the diff boundary, checks, behavioral proof, and remaining uncertainty.

Phase 3 is complete only when the requested behavior is proven locally or in the authorized environment and Maxi accepts the implementation evidence. Wait for him to start Phase 4.

## Phase 4 — Publish, prove, and hand off

1. Before opening the PR, assemble its complete body with `engineering-brief`'s pull-request branch and the repository template. The first published body must link the task title or ID to the Task File's direct `airtable.com` `sourceUrl` and include correctly spelled `### Before` and `### After` sections with proofread image alt text; never open with a bare task number, Task Mirror link, placeholder evidence, or missing section. Use the Phase 2 broken reference for `Before` and the Phase 3 verified result for `After`. For visible changes, capture `After` at a wide desktop viewport that preserves the full desktop layout rather than a compact laptop breakpoint, upload every screenshot with `vitehub-drop`, and embed each returned public URL as `![descriptive alt text](https://drop.vitehub.dev/i/<id>)`. Never embed a localhost, tailnet, temporary artifact, private blob, filesystem, or ordinary `[text](url)` link as screenshot evidence. For non-visual changes, put the equivalent behavioral evidence under the same headings. Then reconcile Git state, create the normal branch, commit conventionally, push, and open the draft PR without mentioning or assigning people. Re-fetch the published body and verify that GitHub renders every expected image before applying and verifying the Implemented Airtable effect.
2. Wait for the PR preview. Verify the fix on the isolated preview when that can be done without customer credentials, sessions, or data, and replace or strengthen the existing `After` evidence when the preview provides better proof. Route every replacement image through `vitehub-drop` and repeat the GitHub render check after updating the body. Preserve the direct Airtable link and complete `Before`/`After` structure during every body update. Keep the preview URL and admin credentials out of the PR body because the deployment comment is their canonical surface, and record only the setup and limitations needed to understand the proof. If the preview requires customer access, do not log in; retain the Phase 3 behavioral proof and state the preview limitation.
3. Self-review the task, diff, repository rules, and preview behavior. Repair every in-scope finding and repeat affected checks.
4. Keep the PR draft until one non-author human has reviewed the current code head. The author's self-review and automated reviews do not count as the second set of eyes. If no reviewer is already approved, ask Maxi to name or approve one, then request only that reviewer without posting a comment. Repair every actionable peer finding and repeat affected checks; if remediation changes code, obtain follow-up review of the new head.
5. Mark the PR ready only after the peer-review gate, final checks, and preview proof pass. Restore any isolated preview data changed during proof or explicitly hand off its remaining state, then tell Maxi the PR needs his manual second pass.

The flow is complete only when a non-author human has reviewed the current code head with no actionable findings left, the PR is ready for Maxi's review, its body carries the decision-relevant proof, a live CLI read shows the automatic PR comment and status, and temporary reproduction state is accounted for. Route later review feedback through `pr-refiner`.
