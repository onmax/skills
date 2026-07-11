---
name: grilling
description: Interview the user relentlessly about a plan or design. Use when the user wants to stress-test a plan before building, get grilled on a design, or another skill needs a grilling session.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

Near the end, before writing a final recommendation, ADR, PRD, issue plan, implementation plan, or handoff, run `validate-direction` on the emerging direction. Use its verdict to either proceed, revise the direction, or ask one final blocking question.
