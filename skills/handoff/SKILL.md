---
name: handoff
description: Writes a compact handoff document so another agent or future session can continue the work without replaying the whole conversation. Use when the user asks to hand off, compact context, continue later, summarize current state for another agent, or preserve next steps before ending a session.
argument-hint: "What should the next session focus on?"
---

# Handoff

## Quick Start

Use this when the useful context is in the conversation, terminal output, changed files, or linked artifacts, and the next agent needs a clean continuation point.

Write a handoff document to the temporary directory of the user's OS, not the current workspace. Resolve the temp directory with the platform temp-dir API or environment, such as `$TMPDIR` on macOS/Linux or `%TEMP%` on Windows.

Write the handoff under a project and topic folder:

```text
<os-temp-dir>/handoff/<project>/<topic>/handoff.md
```

If the project or topic is unclear, infer short slugs from the current task, such as `vitehub/auth-debug`, `skills/readme-polish`, or `nuxt/runtime-config`.

## Workflow

1. Identify the handoff topic, absolute project root, current branch or repo state, and why the handoff is needed.
2. Pick short `<project>` and `<topic>` slugs using lowercase words joined by hyphens.
3. Create `<os-temp-dir>/handoff/<project>/<topic>/handoff.md`.
4. Read the file before writing if it already exists.
5. Write only the context a fresh agent needs to continue.
6. Return the handoff path and the next recommended action.

## Artifact Layout

```text
<os-temp-dir>/handoff/<project>/<topic>/
+-- handoff.md
```

`handoff.md` must include `project_root` as an absolute path. Any project file reference in the handoff must be absolute, such as `/Users/maxi/vitehub/vitehub/packages/client/src/index.ts`. Never use repo-relative paths like `packages/client/src/index.ts` inside temporary artifacts unless they are paired with the absolute `project_root`.

## What To Include

- project and absolute project root
- current goal
- important decisions already made
- files, branches, issues, PRs, commits, or artifacts to inspect
- commands already run and the meaningful results
- known blockers, risks, and assumptions
- next concrete steps
- suggested skills, if any

## What To Avoid

- Do not duplicate full PRDs, ADRs, issues, diffs, or long logs. Link or reference them by path or URL.
- Do not include secrets, API keys, tokens, passwords, or private personal data.
- Do not write a narrative transcript. Preserve the state, not the whole conversation.
- Do not save the handoff inside the project unless the user explicitly asks.

## Output Shape

```md
Handoff written:
- <absolute-handoff-path>

Next:
- ...
```
