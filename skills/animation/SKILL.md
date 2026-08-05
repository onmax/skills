---
name: animation
description: Designs, finds, implements, audits, and reviews interface animation with Emil Kowalski's interaction principles. Use when the user explicitly asks for animation, motion, transitions, easing, spring behavior, or animation polish.
disable-model-invocation: true
argument-hint: "What should animate, or what animation should be reviewed?"
---

# Animation

Route one animation task to the smallest useful reference set, then execute it in the existing visual language.

## Route

- **Design or implementation:** read [vocabulary.md](references/vocabulary.md), [standards.md](references/standards.md), and the UI craft guidance in [interface-craft.md](../ui/references/interface-craft.md).
- **Find opportunities:** read [opportunities.md](references/opportunities.md). Return a prioritized plan unless the user also asked to implement it.
- **Audit a surface:** read [audit-workflow.md](references/audit-workflow.md), [audit-standards.md](references/audit-standards.md), and [plan-template.md](references/plan-template.md).
- **Review existing motion:** read [review.md](references/review.md) and [standards.md](references/standards.md).
- **Apple-platform behavior:** add [apple-design.md](../ui/references/apple-design.md) only when the platform or interaction calls for it.

Use no more than three references unless the task genuinely spans multiple branches.

## Principles

Motion should explain state, preserve spatial continuity, and make an interface feel responsive. Keep frequent interactions fast, make interruption safe, prefer transforms and opacity, and remove motion that delays the user's next action. Copy Emil Kowalski's reasoning, not his branding or prose.

Inspect the current implementation before proposing a motion language. Reuse existing primitives and reduced-motion behavior. Verify the result in the browser when a preview is available, including rapid repeated interaction and keyboard use.

## Output

State the route and references used. Report what changed, why the motion earns its cost, how it behaves under interruption and reduced motion, and what could not be verified.
