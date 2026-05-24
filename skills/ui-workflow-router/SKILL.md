---
name: ui-workflow-router
description: Routes UI work through the user's preferred evolving reference stack and clarifies whether the task needs broad design judgment, external inspiration, or narrow visual adjustment. Use when the user asks to use ui, ui-skills, gh:ibelick/ui-skills, Mobbin, wants something visually good without specifying details, or asks for spacing, color, compactness, layout, table, selector, button, or visual hierarchy adjustments.
---

# UI Workflow Router

## Quick Start

Use this skill before implementation when UI work depends on taste, spacing, color, layout, component composition, or external design references.

Default assumption:

- If the user says they do not care about design, choose a polished direction that matches the existing product aesthetics.
- If the user asks for spacing, colors, compactness, or small visual tweaks, keep scope narrow and preserve the existing structure unless it blocks the requested improvement.

## Reference Loading

1. Load `/Users/maxi/.agents/skills/ui/SKILL.md`, then fetch `uidotsh://ui` and follow its subskill routing.
2. Inspect `gh:ibelick/ui-skills` read-only when it would improve the visual direction or when the user names it.
   - Prefer a temporary clone or existing local clone.
   - Pull or re-clone only when the task depends on current reference content.
   - Do not vendor, copy, or permanently edit the reference repo.
3. Use Mobbin MCP when the user asks for inspiration, examples, onboarding flows, mobile app patterns, SaaS/product references, or multiple UI directions.
4. Use project-local design systems, component libraries, and existing pages before inventing a new visual language.

## Routing Modes

### Broad Design Delegation

Use when the user says things like:

- "I don't care about the design, just make it good."
- "Make it match the aesthetics I am going for."
- "Use ui and gh:ibelick/ui-skills."
- "Make this page/component look better."

Workflow:

1. Read the existing UI surface, component library, and nearest similar screens.
2. Load the closest `uidotsh://ui` subskill; use `design` as fallback.
3. Use `gh:ibelick/ui-skills` for current examples, patterns, or interaction references when useful.
4. Search Mobbin when real product references would improve the direction.
5. Choose one coherent direction and implement it.
6. Verify visually with the browser skill when a local app or preview is available.

### Inspiration Search

Use when the user says things like:

- "show me inspirations"
- "use Mobbin"
- "find references"
- "give me a few options"
- "what do other apps do?"

Workflow:

1. Search Mobbin MCP with the closest user-facing UI pattern, not internal implementation terms.
2. Use `web` for desktop/SaaS/admin/product surfaces and `ios` for mobile-app flows.
3. Prefer `deep` mode for nuanced product flows and `fast` mode for quick visual lookup.
4. Summarize patterns and trade-offs instead of copying a single screen.
5. Carry only the relevant visual decisions into implementation.

### Adjustment-Only

Use when the user mainly wants:

- spacing or density changes
- color or contrast changes
- compactness
- row, table, selector, button, label, icon, or visual hierarchy fixes
- responsive polish on an existing design

Workflow:

1. Keep the existing design direction.
2. Identify the smallest set of layout, spacing, typography, color, or component changes that solve the complaint.
3. Use `uidotsh://ui` subskills such as `make-responsive`, `canonicalize-tailwind`, `componentize`, or `finalize` only when they match the requested edit.
4. Avoid broad redesign unless the current structure is the cause of the issue.
5. Verify that text, controls, and dynamic states fit without overlap.

## When To Grill Or Research

Use `grill-me` only when the UI choice depends on product intent, workflow priority, audience, or a fork in the interaction model.

Use `evidence-research` when the decision would change based on:

- prior Codex session patterns
- external app precedents
- design system conventions
- current `ui-skills` examples
- Mobbin reference patterns
- ecosystem norms for a specific UI pattern

Ask at most one focused question before implementation. Prefer answering discoverable questions by reading the codebase, running the app, or inspecting references.

## Output Expectations

Before editing, state the selected mode and references being loaded.

After editing, report:

- what UI surface changed
- which mode was used
- whether browser verification ran
- any remaining visual risk, especially if a local preview was unavailable
