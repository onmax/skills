# Research Rigor

## Source-Area Matrix

Before spawning subagents, write a source-area matrix in `brief.md`. Each row must name:

- source area
- why it is comparable
- priority sources
- report path
- questions this source area must answer
- what would change in the target design if this source area is persuasive

For broad platform or library design questions, consider splitting into official vendor docs, technical blogs, source repositories, comparable libraries, academic or benchmark papers, security or operations writing, and user-facing product documentation. Only include source areas that can change the decision. For `standard` research, prefer one source area unless separate areas are meaningfully independent and worth parallel surveillance.

## Subagent Reports

Each subagent prompt should include the `brief.md` path, assigned source area, report path, chosen depth, source minimum for that area, whether source cloning into `sources/` is useful, a no-repo-mutation requirement, and a request for source links, trade-offs, patterns, disagreements, recommendations, and evidence-versus-inference separation.

Use at least one subagent. Default to one subagent for `targeted` and `standard` research. Use multiple subagents only when source areas are meaningfully independent, likely to change the decision, and worth the extra latency, such as framework ecosystems, product ecosystems, company technical writing, benchmarks, security literature, Codex session clusters, PR stacks, and repository history. Record the reason for multiple subagents in `brief.md`.

Subagents must write the requested report file. A progress message without a report is incomplete.

## Source Guidance

Prefer authoritative and current sources: official docs, source repositories, technical blogs from relevant companies, design notes, RFCs, changelogs, and established comparable libraries or products.

"Others" means comparable systems facing a similar design challenge. Ask the subagent to justify why each comparison is relevant.

Do not stop at vendor docs for ambitious research if source repositories, benchmark papers, security writing, or competing products can change the decision.

Every report must distinguish:

- direct evidence from a source
- interpretation of what the source implies
- applicability limits for the current project
- disagreements between sources

Avoid source padding. If a source is weak or only adjacent, label it as adjacent and explain why it still matters.

## Finding Verdicts

Every major synthesis claim must use this shape:

```md
Claim:
Verdict: SUPPORTED | CONTESTED | WEAK | INCONCLUSIVE
Evidence:
Inference:
Applicability:
Confidence:
What would change in our design:
```

Verdict rules:

- `SUPPORTED`: multiple authoritative sources point in the same direction, and applicability to the project is clear.
- `CONTESTED`: credible sources disagree, or the pattern changes by ecosystem, repository, scale, or product constraints.
- `WEAK`: evidence is adjacent, anecdotal, old, vendor-specific, or not enough to drive a decision alone.
- `INCONCLUSIVE`: sources do not answer the question, or the research method was not strong enough to resolve it.

Separate decision-changing evidence from background context. Background can explain the landscape, but it must not carry the recommendation unless it changes the target design.

## Completion Gate

Before writing `synthesis.md`, verify:

- each expected report path exists
- each report contains source links with relevance notes
- each report answers its assigned questions
- each report has patterns, trade-offs, recommendations, and applicability limits
- broad or high-stakes research has evidence-versus-inference separation
- no report only summarizes one vendor/source family unless it was explicitly assigned that narrow area
- each major synthesis claim has a finding verdict
- decision-changing evidence is separated from background context

If any report fails the gate, send a follow-up prompt to that subagent or run a local repair pass before synthesis. In the final answer, mention any report that remained weak and why.
