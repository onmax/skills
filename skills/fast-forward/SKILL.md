---
name: fast-forward
description: Fast-forwards low-uncertainty branches inside grilling sessions by stating assumed answers and jumping to the next non-obvious question. Use when the user says fast-forward, skip this branch, this is obvious, same as me, not interesting, or asks to move to the next unclear area during grill-me or grill-with-docs.
---

# Fast Forward

## Quick Start

Use this as a companion maneuver inside `grill-me` or `grill-with-docs`.

When the user signals that the current line of questioning is obvious or low-value, do not end the grilling session. Instead:

1. Identify the current question branch.
2. Infer the likely default answers.
3. State the assumptions compactly.
4. Treat the branch as provisionally resolved.
5. Jump to the next genuinely uncertain branch.
6. Continue with one question.

## Workflow

Use this response shape:

```md
Fast-forwarding this branch.

I am treating these assumptions as provisionally resolved:
- ...
- ...

Next unclear branch: ...

Question: ...
```

Keep the assumptions short. The goal is to remove boring detail, not create a new report.

## Composition Rules

- Follow the active grilling skill's behavior.
- In `grill-me`, this only changes conversation flow.
- In `grill-with-docs`, documentation still follows `grill-with-docs` rules.
- If fast-forwarded assumptions would be written to `.agents/CONTEXT.md` or an ADR under `.agents/adr/`, ask for explicit confirmation before writing.
- For conversation-only fast-forwarding, implicit confirmation is enough: state assumptions and continue.

## What To Skip

Fast-forward branches where:

- the user says the topic is obvious or not interesting
- the likely answer is already implied by resolved decisions
- the branch is implementation detail below the current design level
- the agent and user are likely aligned and no meaningful trade-off remains

Do not fast-forward when:

- the branch contains a real unresolved trade-off
- terms conflict with an existing glossary
- the user is asking for careful review or adversarial challenge
- the next step would mutate files without confirmation

## Example

User:

> fast forward, this is obvious

Assistant:

> Fast-forwarding this branch.
>
> I am treating these assumptions as provisionally resolved:
> - The hosted client remains the default.
> - Embedded delivery is not part of the public API.
> - Package-local opt-out is enough for now.
>
> Next unclear branch: how feature discovery should be represented.
>
> Question: should discovery use one shared endpoint or one endpoint per feature?
