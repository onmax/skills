---
name: fast-forward
description: Prunes one user-accepted branch inside a grilling session. Use when the user asks to skip it or accepts the current recommendation.
---

# Fast Forward

Prune exactly one current branch per user signal inside an active `grilling` session, including sessions started through its wrapper skills.

Treat `your recommendation` and equivalent replies as acceptance of the recommendation already attached to the current question.

1. Name the branch being pruned.
2. State the accepted answer as one or more provisional assumptions.
3. Mark only that branch provisionally resolved and leave adjacent branches open.
4. Name the next genuinely uncertain branch.
5. Ask exactly one next question, then return control to the active grilling skill.

The maneuver is complete when the response contains the pruned branch, its provisional assumptions, the next unclear branch, and one question.

The user's signal is enough for conversation-only pruning. Ask for explicit confirmation before persisting fast-forwarded assumptions in durable project documentation.
