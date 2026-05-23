---
name: pr-body
description: Writes or reviews GitHub pull request bodies in the repository's preferred style with automatic issue linking. Use when opening, updating, or checking a PR body.
---

# PR Body

## Quick Start

Use this whenever an agent opens or edits a pull request.

First inspect repository style:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE/`
- `PULL_REQUEST_TEMPLATE.md`
- `CONTRIBUTING.md`
- recent merged PRs when templates are absent or unclear

## Rules

- Follow the repo template when one exists.
- Without a template, prefer one to three natural paragraphs that explain what changed, why it exists, and reviewer-relevant context.
- Use GitHub automatic linking. Prefer `Closes #123` when merging this PR should close the issue; use `Refs #123` when it should not.
- Add links to issues, docs, ADRs, or related PRs only when they reduce reviewer effort.
- Do not invent boilerplate headings such as `## Summary`.
- Do not add `Validation`, `Tests`, or internal command-log sections unless the template or user explicitly asks.
- Keep commands run in the final chat summary, not in the PR body.
- Use structured sections only when they carry operational meaning, such as hard dependency or coordination notes.
- Preserve existing repository wording when it is already clear.

## Examples

Template absent, issue should close on merge:

```md
Adds source-backed workspace fetch support and updates the public package contract so consumers can read live data through the workspace API.

Closes #123
```

Related issue only:

```md
Narrows the storage capability tool surface so agents expose the intended read and write operations without legacy aliases.

Refs #123
```

## Dependency Notes

Add dependency or coordination notes only when operationally meaningful:

- Hard dependency: the PR must not merge until another PR lands or this branch is rebased.
- Coordination: PRs can merge independently but touch conflict-prone surfaces.

Do not add or update dependency markers without the caller's consent when editing an existing PR body.
