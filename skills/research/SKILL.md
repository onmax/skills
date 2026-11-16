---
name: research
description: Use when the user asks how others or the industry handle something, what the standard is, or wants evidence before a decision.
---

# Research

Run the research in a subagent. The prompt you write is the research; the subagent's final answer is the result. Write no files: the result comes back in chat.

Skip the subagent when a quick lookup or a few links settle the question.

## Write the prompt

The subagent sees none of this conversation, so the prompt must stand alone. Include:

1. **Question.** One decision in one sentence, e.g. "How do comparable libraries handle X, and which approach fits us?"
2. **Context.** What we're building, constraints, what was already tried or ruled out, and what the user cares about in their own words: the owner of a bug, a unit, a UI behavior, the size of a change.
3. **Where to look.** Name comparable projects or vendors and why each is comparable. Primary sources first: official docs, source repos, RFCs, changelogs, maintainers' writing. For questions about our own work: repo history, issues, PRs, logs.
4. **What would change the answer.** The facts that would flip the recommendation, so the subagent looks for them.
5. **Limits.** Read-only: no repo edits, files, PRs, or deploys. Say how deep to go.
6. **Return format.** Paste the one below.

```md
Return, in this order and briefly:
- Answer: the recommendation and its biggest limitation.
- How others do it: per comparable, what they do, a link, and why it applies.
- Common practice vs. what fits our case.
- Disagreements between sources, kept, not smoothed over.
- What is evidence and what is your inference.
- What would reverse the recommendation.
```

Use several subagents only when evidence streams are independent, such as the ecosystem versus our own repo history. Give each its own complete prompt.

## After it returns

- Check that claims rest on linked sources. If something is thin or off-question, ask the same subagent a follow-up instead of filling the gap yourself.
- Reply with the answer first, then only the decisive evidence and links. Fit it to what the user asked: owner, unit, behavior, or scope.
- Research doesn't authorize changes. Act on it only when the user asks.
