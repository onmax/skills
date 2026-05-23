# Pattern Rubric

Use this rubric to turn noisy session history into concrete skill-system improvements.

## Evidence Classes

- **User correction**: the user had to redirect, clarify, reject, or repeat an instruction.
- **Skill miss**: a relevant skill existed but was not invoked, was not discoverable, or was invoked too late.
- **Routing gap**: the active skill did not clearly hand off to a better skill.
- **Instruction gap**: the skill was invoked but lacked a rule, workflow step, output shape, or safety guard.
- **Context gap**: the agent lacked project language, ADRs, repo facts, GitHub state, or Codex session evidence.
- **Tooling gap**: the task needed a query, CLI recipe, command, or deterministic helper to avoid repeated manual work.
- **Verification gap**: the agent finished without the check that would have proven the work.
- **Scope gap**: the agent over-expanded, under-scoped, or mixed unrelated work.
- **Mutation gap**: the agent changed files, GitHub state, Linear state, or runtime state without enough consent.
- **Successful pattern**: a workflow, skill route, checklist, or tool sequence repeatedly worked and should be preserved.

## Severity

- **High**: repeated user corrections, unsafe mutations, wrong repository/branch, missing consent, lost work, or failed published work.
- **Medium**: repeated inefficiency, missing verification, unclear handoff, wrong skill route, or avoidable backtracking.
- **Low**: naming friction, output shape mismatch, discoverability issue, or one-off confusion.

## Recommendation Types

- **Edit existing skill** when the behavior belongs to a current skill and can be fixed with a clearer trigger, workflow step, guardrail, or output shape.
- **Add routing** when two existing skills are both useful but the handoff is unclear.
- **Add reference doc** when the main skill should stay short but needs a deeper rubric, query guide, checklist, or examples.
- **Add CLI recipe** when evidence collection or validation is deterministic and likely to repeat but not yet stable enough for a script.
- **Create new skill** when the job has a distinct trigger, workflow, and output that would overload existing skills.
- **Leave manual** when the pattern depends on judgment, privacy, one-off context, or explicit user consent.

## Analysis Questions

- Which user corrections happened more than once?
- Which skills were named by the user because the agent did not route there on its own?
- Which failures would have been prevented by reading session history, GitHub state, or project memory first?
- Which tool calls were repeated enough to deserve a CLI recipe or reference guide?
- Which recommendations are about wording, and which are about workflow?
- Which failures are actually repository-specific and should become project memory instead of global skill instructions?
- Which successful behaviors should be protected from future over-refactoring?

## Evidence Ledger Shape

```md
| Time | Source | Session/PR | Action | Skill/tool | Result | Pattern |
| --- | --- | --- | --- | --- | --- | --- |
| ... | Codex | ... | ... | ... | ... | ... |
| ... | GitHub | ... | ... | ... | ... | ... |
```

Keep the final answer shorter than the ledger. The ledger exists to make recommendations defensible, not to flood the user.

## Backlog Rules

- Put repeated patterns in `Skill improvements` when the fix is clear.
- Put a single incident in `Skill improvements` only when severity is high.
- Put suggestive but incomplete evidence in `Investigations`.
- Put workflows that deserve a distinct trigger and output in `New skill candidates`.
- Put behaviors that already work in `Keep`.
- Put judgment-heavy or consent-heavy habits in `Leave manual`.
