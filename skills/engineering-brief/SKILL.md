---
name: engineering-brief
description: Writes or reviews evidence-backed issue reports, implementation requests, and pull request bodies for engineers. Use when investigation or implementation context must become a concise, actionable artifact, including visual proof when it helps.
---

# Engineering Brief

Turn verified engineering evidence into the smallest durable artifact that lets the next reader act. Shape the artifact; do not redo the investigation, publish it, or mutate an external system unless the caller separately authorizes that work.

## Choose the branch

Choose by the reader's next job, then read only that reference:

- Report an observed failure: [issue-report.md](references/issue-report.md)
- Request a known change: [implementation-request.md](references/implementation-request.md)
- Explain a completed change for review: [pull-request.md](references/pull-request.md)

If the direction is still disputed, validate it before writing a request. If the cause is still unknown, report the evidence and uncertainty rather than inventing an explanation.

## Workflow

1. **Name the reader and decision.** Identify who will read the artifact and what they need to decide or do next. Follow the destination's required fields or repository template.
2. **Inventory facts before prose.** Collect the observed or changed result, expected or requested result, why it matters, confirmed mechanism, reproduction or acceptance evidence, source links, useful code paths, visuals, and remaining uncertainty. Label inference as inference.
3. **Discard the transcript.** Preserve conclusions and proof, not the chronology of commands, hypotheses, dead ends, infrastructure counts, or agent activity that produced them.
4. **Draft outcome first.** The opening should make the unexpected result, requested outcome, or completed change understandable without a heading. Add structure only when it helps the reader navigate distinct decisions.
5. **Attach decision-relevant evidence.** Put links and visuals next to the claim they support. A code path belongs only when it shortens the route to the relevant seam.
6. **Cut until every sentence earns its place.** Keep a detail only when it changes diagnosis, implementation, review, risk, or acceptance. Preserve clear existing wording when reviewing an artifact.
7. **Verify the artifact.** Re-read it from the target reader's perspective and check every link, image, identifier, and claim against the source evidence.

## Visual evidence

- Use screenshots for visible states that prose cannot establish as quickly. They are evidence, not decoration.
- Show before and after, or current and expected, when the comparison changes the decision.
- Write alt text that states the relevant observation rather than saying only “screenshot.”
- Keep copyable commands, errors, identifiers, and values as text even when they also appear in an image.
- Use durable public image URLs for published artifacts. Let the caller's publishing workflow choose the approved upload mechanism.
- Before attaching or uploading, remove credentials, tokens, customer data, private URLs, session details, and unrelated personal information. If safe redaction would weaken the proof, omit the image and describe the evidence in text.

## Completion criterion

The artifact is complete when its intended reader can answer:

- What happened, is requested, or changed?
- Why does it matter?
- What evidence supports it, and what remains uncertain?
- What action or observable result completes the work?

It must contain no unsupported claim, broken evidence, sensitive information, investigation-log sediment, or boilerplate section that the destination did not require.
