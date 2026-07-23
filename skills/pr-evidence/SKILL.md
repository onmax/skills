---
name: pr-evidence
description: Makes an authored pull request body fast to review with visual before-and-after proof, exact preview links, or downloadable artifacts. Use when creating or refreshing PR evidence, screenshots, previews, exports, or generated files.
---

# PR Evidence

Turn the pull request body into the shortest useful manual test surface. Edit it only when the caller already authorizes PR body changes.

## Author gate

Read the pull request author and the authenticated GitHub user. When an autonomous watcher invokes this skill, continue only if they match; otherwise preserve the body unchanged. An interactive caller may provide separate explicit authority.

## Evidence

1. Read the intent, diff, current body, task evidence, checks, and live preview state. Treat old screenshots, links, artifacts, and blocker text as claims to re-verify, not history to preserve.
2. Choose the evidence that lets a human judge the changed behavior fastest:
   - **Visible UI:** capture comparable before and after states at the same route, viewport, data, and interaction state. Prefer one compact comparison table over separate prose sections.
   - **Export or generated file:** produce the real file from the changed path, inspect its decision-relevant contents, upload it with `vitehub-drop`, and link it as a download. Add a screenshot only when visual inspection communicates the change faster than opening the file.
   - **Behavior without a useful visual:** give the smallest concrete input/output, request/response, or reproduction result. Do not turn commands, CI chronology, or investigation notes into body evidence.
3. For a working PR environment, link the exact deep route beside the evidence as `[Open the PR preview](<url>)`. A deployment homepage or deployment comment is insufficient when the changed state lives deeper.
4. Replace weaker or stale evidence instead of appending. Remove resolved blocker text, obsolete setup, duplicate screenshots, and claims contradicted by current checks or preview state.
5. Re-read the rendered body and every public URL. Completion requires the comparison or artifact to render or download, the preview link to open the changed state when available, and no stale claim to remain.

## Body shape

Keep the outcome sentence and task link already required by the repository. Then use the smallest matching shape.

For visible UI:

```md
[Open the PR preview](https://preview.example.test/exact/route)

| Before | After |
| --- | --- |
| ![Before: concrete state](https://...) | ![After: concrete state](https://...) |
```

For an export or generated file:

```md
[Open the PR preview](https://preview.example.test/exact/route) · [Download the verified export](https://...)

The highlighted cells are numeric and retain the expected Excel number format.
```

Use one short `### Before` and `### After` pair only when comparable media cannot be shown side by side. Never pad an absent visual with speculative prose.
