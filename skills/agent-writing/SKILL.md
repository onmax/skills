---
name: agent-writing
description: Writes or revises prompts and SKILL.md files as compact agent instructions. Use only when the user explicitly asks to write, improve, or consolidate a prompt or skill.
disable-model-invocation: true
argument-hint: "What prompt or skill should be written or revised?"
---

# Agent Writing

Choose one branch, preserve the user's real constraints, and remove instructions the model already follows without being told.

Before either branch, read the shared [writing glossary](../writing-great-skills/GLOSSARY.md). Use its terms consistently.

## Prompt Branch

Read [prompts.md](references/prompts.md). Use [prompt-examples.md](references/prompt-examples.md) only when examples would clarify a difficult behavior or format.

Write the shortest prompt that reliably produces the requested outcome. Put the goal and concrete deliverables first, keep constraints close to the behavior they govern, state authority boundaries explicitly, and replace vague quality language with observable checks.

## Skill Branch

Read [skills.md](references/skills.md). Inspect neighboring skills and real usage before choosing a name or trigger description. Keep `SKILL.md` as the decision surface; move detailed procedures, examples, and command recipes into references that are loaded only by a named branch.

Set `disable-model-invocation: true` when the skill represents an explicit workflow, expensive context, a mutation boundary, or an action the model should never infer. Preserve automatic invocation only when the trigger is narrow and the skill is useful whenever that trigger appears.

## Validation

Check YAML frontmatter, local links, trigger wording, progressive disclosure, and conflicts with adjacent skills. When revising an existing instruction, show the behavioral change and why it reduces ambiguity or context cost.
