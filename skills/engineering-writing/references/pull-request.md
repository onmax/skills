# Pull request body

Write for the reviewer deciding whether the completed change is correct, appropriately scoped, and safe to merge.

## Repository style first

Inspect, in order:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE/`
- `PULL_REQUEST_TEMPLATE.md`
- `CONTRIBUTING.md`
- recent merged pull requests when templates are absent or unclear

Follow the repository template when one exists, and use recent accepted pull requests to calibrate local tone without discarding required fields. Without a template, prefer one to three natural paragraphs covering what changed, why it exists, and the context that changes the review decision.

## Rules

- Lead with the changed behavior or capability, then explain the reason and reviewer-relevant boundary. Name a shortcoming or area needing focused review when it materially changes confidence.
- Use `Closes #123` when merging into the default branch should close the issue and `Refs #123` when it should not.
- Link issues, tasks, docs, ADRs, or related pull requests only when they reduce reviewer effort.
- Restate the decision-relevant conclusion from private chats, tasks, previews, or other access-limited links.
- Do not invent `Summary`, `Validation`, `Tests`, or command-log sections unless the template or user requires them. Include behavioral proof or the reason it is absent when the destination or risk expects it, but keep raw commands in the final handoff.
- Use structured sections only when they carry operational meaning or make substantial evidence easier to compare.
- For visible changes, prefer focused before-and-after evidence with descriptive alt text and complete text setup. For non-visual changes, provide equivalent behavioral evidence when the repository expects proof.
- Preserve clear existing wording when editing a body. Do not replace a useful body with a generic template.

## Dependencies and coordination

Add a dependency note only when the pull request must wait for another change or be rebased after it. Add a coordination note only when independently mergeable changes touch conflict-prone surfaces.

Do not add or change dependency markers without the caller's consent when editing an existing pull request body.

## Examples

```md
Adds source-backed workspace fetch support so consumers can read live data through the public workspace API.

Closes #123
```

```md
Narrows the storage capability surface to the intended read and write operations, removing the legacy aliases that made tool selection ambiguous.

Refs #123
```
