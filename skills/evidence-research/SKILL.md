---
name: evidence-research
description: Researches one decision using auditable internal or external evidence. Use when current sources, repository history, precedent, or competing claims could materially change a technical or product decision.
---

# Evidence Research

Research one decision whose answer could change with better evidence. Prefer direct repository history, task transcripts, primary documentation, and exact runtime evidence over summaries. Use ordinary lookup when a few facts or links settle the question.

## Method

1. State the decision and the facts that would reverse it.
2. Choose `internal`, `ecosystem`, or `mixed` sources and explain why.
3. Separate observed facts, sourced claims, inference, and unresolved gaps.
4. Search the narrowest authoritative sources first. Memory may locate evidence but does not replace the original message, commit, log, document, or runtime result.
5. Load [RESEARCH-RIGOR.md](RESEARCH-RIGOR.md) when the user asks for an auditable artifact, multiple evidence streams must be reconciled, or source quality is contested.
6. Synthesize the evidence into decision pressure, including evidence against the preferred answer.

Keep the project repository unchanged unless the user separately asks to apply the decision. Store requested research artifacts in the OS temporary directory with absolute source paths and links. Delegate only independent evidence streams whose separation improves the result.

## Output

Lead with the answer the evidence supports and its strongest limitation. Then give the decisive evidence, meaningful disagreement, what is inference, and the condition that would reverse the recommendation. Include exact artifact paths only when artifacts were requested or required by the rigor branch.
