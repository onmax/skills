---
name: write-a-prompt
description: Writes and tightens compact, execution-ready prompts for coding agents and persistent agent instructions. Use when the user asks to draft, rewrite, structure, or reduce a task prompt, agent prompt, system prompt, or instructions file.
---

# Writing Agent Prompts

A prompt is an executable contract. Spend tokens only on context and decisions the target agent cannot reliably infer.

## Steps

1. **Choose the lifespan.** Classify the artifact before writing:
   - A task prompt carries current state toward one outcome.
   - Persistent instructions define stable identity, evidence, capabilities, authority, and response behavior across requests.

   The classification is complete when temporary state has one clear home and cannot leak into persistent instructions.

2. **Ground the prompt.** When the target project is available, inspect its applicable instructions and the nearest representative prompt. Preserve the user's exact skill names, project language, targets, and authority. When the project is unavailable, use only conversation evidence and expose any assumption that would change execution.

   Grounding is complete when every concrete path, tool, capability, and constraint is supported rather than invented.

3. **Extract the contract.** Identify the outcome, target, necessary context, ground truth, skills or capabilities, authority boundary, and proof of completion. Omit an element when it does not change execution.

   The contract is complete when the target agent can act without reconstructing intent or asking for information already available.

4. **Compose with skills.** Name the smallest applicable skill set and let each skill own its process. State any task-specific reason or boundary the skill cannot know; never paste the skill's workflow into the prompt. Inherit repository and harness instructions instead of restating them.

5. **Draft in execution order.**
   - For a task prompt: outcome and target, current evidence, required skills or capabilities, authority and constraints, then verification and stopping condition.
   - For persistent instructions: identity and audience, evidence and source routing, capabilities, authority, then answer contract.

   Use headings only when they co-locate rules the agent must consult together. Prefer natural prose for a short prompt.

6. **Prune sentence by sentence.** Delete role theatre, rationale addressed to the author, generic quality requests, duplicated meaning, copied skill instructions, speculative implementation detail, and empty structure. Prefer the positive target behavior. Keep prohibitions for real safety or authority boundaries and pair them with the permitted action.

7. **Return the artifact.** Edit the requested file when authorized. Otherwise return the finished prompt in one copyable block. Add commentary only when the user asks for it or an unresolved assumption materially affects execution.

When there is no representative prompt to refine, use [EXAMPLES.md](EXAMPLES.md) as a shape reference. Copy its information order, not its wording or headings.

## Review Gate

Before finishing, verify:

- The opening tells the target agent what it owns or must accomplish.
- Every current fact belongs in a task prompt; every persistent rule remains useful across requests.
- Skills, tools, sources, and paths are named exactly and only when available.
- Mutation and external-action authority are explicit where ambiguity would be risky.
- The completion criterion is observable and proportionate to the task.
- Each remaining sentence changes behavior, and each meaning has one source of truth.
- The prompt is as short as it can be without forcing the target agent to guess.
