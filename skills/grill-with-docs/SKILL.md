---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates agent-owned documentation under `.agents/` inline as decisions crystallise. Use when the real task is defining purpose, scope, structure, canonical terms, capture/refinement criteria, or other durable decisions for the project.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

If the user rejects a list of questions, gives several answers at once, or asks you to stop making them choose from a list, switch to decision-led mode:

1. State the current recommended direction in one or two sentences.
2. Name the single decision that would most change that recommendation.
3. Ask one focused question only if code or docs cannot answer it.
4. Capture hard constraints immediately before continuing to the next branch.

Every one or two turns, run an altitude check:

1. State the current scope level in one phrase: vision, MVP, workflow, component, or implementation detail.
2. If the conversation has dropped below the level of the unresolved decision, climb back up before asking the next question.
3. If the unresolved decision is still "what is the MVP?" or "what belongs in scope?", do not continue into card formats, review mechanics, page-by-page flows, or implementation choices unless the user explicitly asks.
4. When the user signals "this is getting too specific" or the plan keeps expanding sideways, route to `simplify` and use its smaller target as the next grilling baseline.

Do not restart the interview from the top after an interruption. Resume from the newest user correction and restate only the durable decisions that still matter.

Near the end, before writing or updating a final recommendation, ADR, PRD, issue plan, implementation plan, or handoff, run `validate-direction` on the emerging direction. Use its verdict to proceed, revise the direction, or ask one final blocking question.

</what-to-do>

<supporting-info>

## Research routing

During grilling, recommend `evidence-research` when the next decision depends on internal or external evidence, especially for public APIs, architecture boundaries, developer experience, framework conventions, security-sensitive workflows, vendor/platform trade-offs, retrospectives, or project-history patterns.

Do not silently run evidence research for every design question. First name the decision that evidence would clarify, recommend the source mode and research depth, and ask whether to pause grilling for that research unless the user already asked to research.

When the user asks for research, pause the grilling loop and use the research result as input to the next question. If research artifacts or subagent reports are returned, synthesize their decision-changing evidence before continuing.

When the user asks for repository inspection to understand product scope, architecture, or hidden complexity, inspect the repo before continuing the interview. Use what the code/docs already prove to avoid speculative grilling.

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── .agents/
│   ├── CONTEXT.md
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If `.agents/CONTEXT-MAP.md` exists, the repo has multiple contexts. The map points to where each one lives:

```
/
├── .agents/
│   ├── CONTEXT-MAP.md
│   ├── adr/                          ← system-wide decisions
│   └── contexts/
│       ├── ordering/
│       │   ├── CONTEXT.md
│       │   └── adr/                  ← context-specific decisions
│       └── billing/
│           ├── CONTEXT.md
│           └── adr/
├── src/
```

Create files lazily — only when you have something to write. If no `.agents/CONTEXT.md` exists, create it when the first term is resolved. If no `.agents/adr/` exists, create it when the first ADR is needed. Legacy root `CONTEXT.md`, root `CONTEXT-MAP.md`, and `docs/adr/` may be read when present, but new agent context should go under `.agents/` unless the user explicitly asks for the legacy layout.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `.agents/CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

For scheduling, callbacks, background jobs, provider output, deployment configuration, or runtime execution, force the buildtime/runtime split early. Ask which behavior is static configuration, runtime state, bookkeeping, provider output, and actual execution before allowing the direction to harden into issues or ADRs.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Reconcile handoffs and parallel sessions

When the user provides handoff files, active-session summaries, or parallel-session context, read and reconcile those artifacts before asking the next design question. Prefer the newest handoff when it updates or supersedes older framing, and state the specific decision or term that changed.

### Implementation gate

Use this skill to reach shared understanding, not to implement.

During grilling, only write `.agents/` context or ADR files. Do not edit source, tests, config, package files, or other project docs.

If the user says "grill with docs and fix this", treat the fix as the post-grilling goal. Finish the grilling loop, then ask before implementing.

If the grilling session is happening inside a personal repo such as Bitácora de Vida and the durable outcome is a product-scope clarification rather than glossary policy, prefer writing a small ordinary Markdown note over forcing the decision into `.agents/CONTEXT.md`.

### Update CONTEXT.md inline

When a term is resolved, update the relevant `.agents/CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`.agents/CONTEXT.md` should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
