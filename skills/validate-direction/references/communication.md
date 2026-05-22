# Communication Lens

## Purpose

Check whether future readers will understand the direction, its trade-offs, and its operational consequences. The artifact should make the next correct move obvious.

This lens is the legibility critic: it asks "what will the next maintainer or agent do after reading this, and will that be the intended move?"

## Vocabulary

- **Future reader**: the maintainer, reviewer, or agent who will act from this artifact later.
- **Decision sentence**: the one sentence that carries the actual direction.
- **Trade-off**: what the direction gains and what it willingly gives up.
- **Rejected alternative**: a plausible path not taken, with the reason.
- **Misreading**: a reasonable but wrong interpretation the wording invites.
- **Scope boundary**: what this direction does not decide.
- **Operational consequence**: what must change in code, docs, migration, release notes, or workflow.

## Critical Posture

Do not polish vague thinking. First identify the likely misreading, then rewrite only what prevents that mistake.

The goal is not prettier prose. The goal is future-correct behavior.

## Questions

- What is the direction trying to make future readers understand?
- What could be misread, overgeneralized, or applied outside its scope?
- Is the decision sentence specific enough?
- Are trade-offs and rejected alternatives explicit enough?
- Does the artifact say what changes operationally?
- Is the wording too vague, too broad, too philosophical, or too implementation-heavy?
- What sentence should carry the decision?

## Failure Modes

- A correct decision hidden behind generic wording.
- A decision that says what to do but not what not to do.
- Treating implementation steps as the decision.
- Omitting the rejected alternative that future readers will naturally rediscover.
- Using broad terms like "plugin", "module", "default", or "hosted" without pinning the intended meaning.
- Leaving migration or breaking-change implications implicit.

## Output

Write `reports/communication.md` with:

1. Intended meaning
2. Decision sentence
3. Likely misreadings
4. Missing trade-offs or rejected alternatives
5. Operational consequences
6. Better wording
7. Strongest communication-based objection
8. Recommendation: `proceed`, `revise`, or `pause`

When citing project files, preserve the absolute paths from `brief.md`. If the brief only contains a repo-relative path, mark it as ambiguous and resolve it against `project_root` before using it as communication context.

Prefer `proceed` when the artifact will cause the next reader to make the intended move.
Prefer `revise` when the direction is sound but the written artifact would invite the wrong future change.
Prefer `pause` when the direction cannot be written clearly because the underlying decision is still unresolved.
