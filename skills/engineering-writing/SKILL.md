---
name: engineering-writing
description: Writes or reviews concise, evidence-backed issue reports, implementation requests, and pull request bodies. Use when investigation, product, or implementation context must become an actionable artifact for engineers, including visual proof when it helps.
---

# Engineering Writing

Turn verified engineering evidence into the smallest durable artifact that lets the next reader act. Shape the artifact; do not redo the investigation, publish it, or mutate an external system unless the caller separately authorizes that work.

## Choose the branch

Choose by the reader's next job, then read only that reference:

- Report an observed failure: [issue-report.md](references/issue-report.md)
- Request a known change: [implementation-request.md](references/implementation-request.md)
- Explain a completed change for review: [pull-request.md](references/pull-request.md)

If the direction is still disputed, validate it before writing a request. If the cause is still unknown, report the evidence and uncertainty rather than inventing an explanation.

## Workflow

1. **Name the reader and decision.** Identify who will read the artifact and what they need to decide or do next.
2. **Assume shared context.** Write for a trusted team that already knows the product and repository. Follow required destination fields, but do not import open-source intake questions. Add environment, reproduction, routing, alternatives, or headings only when their absence would block action. Route security vulnerabilities through the destination's private disclosure process.
3. **Inventory facts before prose.** Collect the observed or changed result, expected or requested result, why it matters, confirmed mechanism, evidence needed to trust the claim, source links, useful code paths, visuals, and remaining uncertainty. Label inference as inference.
4. **Discard the transcript.** Preserve conclusions and proof, not the chronology of commands, hypotheses, dead ends, infrastructure counts, or agent activity that produced them.
5. **Draft outcome first.** The opening should make the unexpected result, requested outcome, or completed change understandable without a heading. Add structure only when it helps the reader navigate distinct decisions.
6. **Attach decision-relevant evidence.** Put links and visuals next to the claim they support. A code path belongs only when it shortens the route to the relevant seam. Restate the relevant conclusion from any private or access-limited source.
7. **Cut until every sentence earns its place.** Keep a detail only when it changes diagnosis, implementation, review, risk, or acceptance. Preserve clear existing wording when reviewing an artifact.
8. **Verify the artifact.** Check every identifier, claim, link, and image against the source evidence. Publish only wording the responsible engineer can understand and defend.

## Visual evidence

- Use screenshots only for load-bearing visual states that prose cannot establish as quickly. Never screenshot logs, code, commands, errors, or other output that should be searchable text.
- Show before and after, or current and expected, when the comparison changes the decision.
- Write alt text that states the relevant observation rather than saying only “screenshot.”
- Keep the setup, observation, commands, errors, identifiers, and values complete in text even when they also appear in an image.
- Use durable public image URLs for published artifacts. Let the caller's publishing workflow choose the approved upload mechanism.
- Before attaching or uploading, remove credentials, tokens, customer data, private URLs, session details, and unrelated personal information. If safe redaction would weaken the proof, omit the image and describe the evidence in text.

## Completion criterion

The artifact is complete when its intended reader can answer:

- What happened, is requested, or changed?
- Why does it matter?
- What evidence supports it, and what remains uncertain?
- What action or observable result completes the work?

It must contain no unsupported claim, broken evidence, sensitive information, investigation-log sediment, or boilerplate section that the destination did not require. A reader must not need access to a private link or an image to recover the core result.
