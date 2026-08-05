---
name: engineering-writing
description: Turns verified engineering context into concise issue reports, implementation requests, and pull request bodies. Use when engineers need an actionable artifact that preserves the reasoning and evidence behind a problem, request, or completed change.
---

# Engineering Writing

Write the smallest artifact that preserves the engineering reasoning and lets the next reader act. Follow the destination's required fields and repository conventions; publishing or changing an external system requires separate authorization.

## Shape the artifact

1. Identify the reader's next decision: diagnose a problem, implement an outcome, or review a completed change.
2. Preserve the causal spine of the strongest verified explanation: what the system or user knew or needed, what happened or changed, and why those facts matter together. Keep distinctive wording that already makes the mechanism clear.
3. Open with that outcome or contradiction. Add current behavior, scope, constraints, implementation detail, and headings only when they change the reader's decision.
4. Separate confirmed facts from inference and remaining uncertainty. When the evidence proves a contradiction but not the correct behavior, ask the narrow investigation question or allow either a correction or an explanation of the constraint.
5. Put decision-relevant values, links, code paths, and visual proof beside the claims they support. Restate the core evidence in text when a source is private, access-limited, or visual.
6. Remove investigation chronology, dead ends, agent activity, raw command logs, generic boilerplate, and details that do not change diagnosis, implementation, review, risk, or acceptance.
7. Verify every claim, identifier, link, and image against the source evidence.

Write in flowing technical prose: direct, conversational, and confident. Keep connected reasoning in complete paragraphs so cause and consequence stay together. Use GitHub Markdown freely—headings, lists, tables, callouts, and code blocks—when it makes distinct evidence easier to understand, without forcing the artifact into a template.

For a pull request, make the changed behavior, its reason, the reviewer-relevant boundary, and the available proof clear. For a problem or request, state an observable completion result only when the evidence supports one; otherwise end at the unresolved decision instead of inventing acceptance criteria.

Use a screenshot only when the visual state carries evidence more quickly than prose. Keep the setup and observation complete in text, use descriptive alt text, and exclude credentials, customer data, private URLs, and unrelated personal information.

The artifact is complete when its reader can recover what happened, is requested, or changed; why it matters; what evidence supports it; what remains uncertain; and what decision or observable result comes next.
