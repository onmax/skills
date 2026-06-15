---
name: ui
description: Root router for UI work that selects the smallest useful design, reference, implementation, or QA context. Use when the user mentions UI, ui-skills, docs.ui.sh, ui.sh, Mobbin, visual quality, spacing, color, compactness, layout, tables, selectors, buttons, responsiveness, or hierarchy.
---

# UI

## Job

Act as the root router for UI work. Choose the smallest useful context, load only that context, then continue the task.

Do not load a separate local `ui` skill as a parent router. Fetch `uidotsh://ui` directly only when ui.sh subskills are the chosen context.

## Protocol

1. Decide if the task is UI-related. If not, say `no UI router needed`.
2. Inspect project-local UI first when code exists: component library, design tokens, nearest similar screens, and current page structure.
3. Pick the smallest context set. Prefer 1 context, use 2 only for clear cross-cutting work, and never use more than 3.
4. Load the selected context before editing. If the route is ambiguous and the answer would change the context, ask one short question.
5. Implement narrowly. Keep existing structure for polish requests unless the structure causes the problem.
6. Verify visually with the browser skill when a local preview exists.

## Context Sources

### Project Local

Default first context for existing apps. Use existing components, tokens, icons, table patterns, forms, density, and neighboring screens before inventing a new visual language.

### docs.ui.sh

Use for Tailwind UI implementation and refinement. Fetch `uidotsh://ui`, match the current subskill list, then fetch the selected subskill or guideline file.

Current common routes:

- new UI, page, layout, section, or component: `design` fallback
- multiple concepts, variants, directions, or options: `ideas`
- production cleanup: `finalize`
- extract reusable components: `componentize`
- Tailwind sorting, conflicts, or duplication: `canonicalize-tailwind`
- dark mode: `add-dark-mode`
- dark-mode source image work: `dark-mode-image`
- responsive retrofit: `make-responsive`

### ui-skills

Use `ibelick/ui-skills` as an external skill registry, not as vendored project code. Use it when the user names `ui-skills`, asks for design-engineering taste/craft, or the task needs a focused external UI skill beyond ui.sh.

Commands:

```bash
npx --yes ui-skills categories
npx --yes ui-skills list --category <category>
npx --yes ui-skills get <slug>
```

Route by topic, stack, then specificity. Prefer one specific skill over broad taste packs. Use two only for clear angles such as accessibility plus motion.

### Mobbin

Use when the user asks for inspiration, real product examples, onboarding flows, mobile app patterns, SaaS/admin references, or multiple UI directions. Search with user-facing UI pattern names, not internal implementation terms.

### Companion Skills

Use installed local skills only when they are the closest match:

- `frontend-design`: distinctive new UI or substantial visual redesign
- `design`: ui.sh-guideline implementation in this environment
- `ideas`: side-by-side options for the user to choose from
- `make-responsive`: breakpoint-specific repair
- `better-icons`: icon search or replacement
- `imagegen`: bitmap visuals or image edits

## Routing Hints

- "make it look better", "make it good": project local + one visual/craft context.
- spacing, density, compactness, hierarchy: project local first; add a layout/craft context only if needed.
- tables, selectors, forms, buttons, dialogs, tabs: project local primitives first; add accessibility context when behavior or labeling changes.
- responsive polish: `make-responsive`.
- dark mode: docs.ui.sh `add-dark-mode`.
- Tailwind cleanup: docs.ui.sh `canonicalize-tailwind`; use `finalize` only for finished UI.
- inspiration or examples: Mobbin or ui-skills, then summarize transferable patterns.
- motion: use existing motion system first; add ui-skills motion context for non-trivial animation.

## Research And Clarifying

Use `grill-me` only when product intent, audience, workflow priority, or interaction model would change the UI route.

Use `evidence-research` when design-system precedent, current ui-skills examples, Mobbin patterns, or ecosystem norms would change the decision.

## Output Expectations

Before editing, state the selected route and contexts being loaded.

After editing, report:

- what UI surface changed
- which route was used
- whether browser verification ran
- any remaining visual risk, especially if a local preview was unavailable
