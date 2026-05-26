---
name: write-a-skill
description: Creates or revises one portable agent skill with concise routing, progressive disclosure, and clear safety boundaries. Use when the user wants to write, clean up, or restructure a skill.
---

# Writing Skills

## Process

1. **Define one job** - identify the task, trigger, and boundary. If the request needs several jobs, split it into several composable skills.

2. **Challenge the shape** - before drafting, compare the request against the Quality Bar. If it would create a broad lifecycle skill, harness-specific wrapper, secret-handling shortcut, or multi-purpose catch-all, say so and propose the smaller composable shape.

3. **Draft the skill** - create:
   - SKILL.md with concise instructions
   - Additional reference files for rarely needed details
   - Utility scripts only for deterministic repeatable operations

4. **Review the shape** - check that the skill is concise, responsible for one thing, composable, progressively disclosed, harness-agnostic, documented, portable, and secure.

5. **Validate direction** - before finalizing a new or materially changed skill, run `validate-direction` on the emerging skill design when the skill changes agent behavior, routing, permissions, workflow sequencing, or cross-skill coordination. Carry the verdict into the final edit before declaring the skill done.

## Skill Structure

```
skill-name/
├── SKILL.md           # Required routing + core workflow
├── REFERENCE.md       # Optional deep details
├── EXAMPLES.md        # Optional examples
└── scripts/           # Optional deterministic helpers
    └── helper.js
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Link to separate files: See [REFERENCE.md](REFERENCE.md)]
```

## Description Requirements

The description is **the only thing your agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills. Your agent reads these descriptions and picks the relevant skill based on the user's request.

**Goal**: Give your agent just enough info to know:

1. What capability this skill provides
2. When/why to trigger it (specific keywords, contexts, file types)

**Format**:

- Max 1024 chars
- Write in third person
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"
- Preserve trigger nouns: product, tool, action, object.
- Avoid describing a whole workflow when the skill only owns one step.

**Good example**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:

```
Helps with documents.
```

The bad example gives your agent no way to distinguish this from other document skills.

## When to Add Scripts

Add utility scripts when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## Quality Bar

Skills should be:

- **Concise**: short enough to load quickly and scan under pressure.
- **Responsible for one thing**: one job, one trigger family, one output shape.
- **Composable**: call or hand off to other skills instead of owning an end-to-end lifecycle. It is good for one skill to mention another when the boundary is explicit.
- **Progressively disclosed**: keep common rules in `SKILL.md`; move rare detail to references or scripts.
- **Harness-agnostic**: describe the job, not one execution harness, unless the skill is specifically about that harness.
- **Well-documented**: include enough examples, rules, and failure modes for another agent to use it correctly.
- **Portable**: avoid absolute local paths and private assumptions unless the skill is explicitly local.
- **Secure**: preserve consent, privacy, and mutation boundaries; never normalize secret-printing or broad state changes.

## Challenge Triggers

Push back before editing when the proposed skill:

- Owns an end-to-end lifecycle instead of one job.
- Combines planning, implementation, review, deployment, and cleanup in one file.
- Exists mainly to wrap a specific harness when a harness-agnostic skill plus a small harness reference would work.
- Repeats another skill's responsibility instead of composing with it.
- Needs many unrelated trigger words to explain when it should load.
- Requires absolute local paths, private accounts, tokens, shell history, or hidden config to be useful.
- Would make the agent mutate GitHub, infrastructure, files, or secrets without explicit consent boundaries.

When pushing back, give the smaller replacement shape:

```text
Instead of one broad skill, split it into:
- <skill-a>: owns ...
- <skill-b>: owns ...
Existing skill to compose with: <skill-name>
```

## When to Split Files

Split into separate files when:

- SKILL.md exceeds 100 lines
- Content has distinct domains (finance vs sales schemas)
- Advanced features are rarely needed

## Review Checklist

After drafting, verify:

- [ ] Description includes triggers ("Use when...")
- [ ] Skill owns one job and composes with other skills for adjacent work
- [ ] SKILL.md is short; rare details are in references
- [ ] No time-sensitive info
- [ ] Consistent terminology
- [ ] Concrete examples included
- [ ] References one level deep
- [ ] Security and mutation boundaries are explicit
- [ ] `validate-direction` was run or explicitly skipped because the edit was mechanical and low-risk
