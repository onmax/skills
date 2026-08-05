---
name: handoff
description: Writes a compact continuation handoff that preserves exact repository state, proof, ownership, decisions, and the next action. Use when work must continue in another task, agent, or session.
argument-hint: "What should the next session focus on?"
---

# Handoff

Write the smallest state package that lets a fresh agent continue without repeating completed work or taking ownership of someone else's changes.

Store it outside the repository at `<os-temp-dir>/handoff/<project>/<topic>/handoff.md`, unless the user explicitly requests a project artifact. Read an existing handoff before updating it.

## Include

- the goal, absolute project root, branch, PR, and exact current state
- decisions already made and constraints that still apply
- dirty files and their owner when known
- commands run and only their meaningful results
- verification completed, exact proof, and what remains unverified
- blockers, risks, assumptions, and the next concrete action
- paths or URLs to source artifacts instead of copied logs, diffs, or documents

Do not include secrets, private personal data, a narrative transcript, or claims of completion that the branch, PR head, preview, or runtime proof does not support.

Return the absolute handoff path and one recommended next action.
