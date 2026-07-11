---
name: validate-direction
description: Validates a direction on explicit request or immediately before an authorized direction hardens into a plan, durable artifact, API, workflow, merge strategy, or implementation.
---

# Validate Direction

Challenge one current direction while it is still cheap to change. Start from the actual direction, preserve the user's intent, and return the smallest correction that makes the next move safe.

Use this on explicit request or immediately before an authorized direction hardens. A direction exists when the next move chooses between plausible alternatives or establishes scope, ownership, a boundary, or an invariant. Route already-specified or mechanical execution straight to work, regardless of whether it includes a small plan.

## Steps

1. State the direction being validated in one plain sentence.
2. Identify the project, absolute project root, lifecycle phase, authorized artifact or action, user constraints, known evidence, and load-bearing unknowns.
3. Reuse existing research, ADRs, code, tests, PR context, and conversation evidence. Gather only missing evidence that could change the verdict.
4. Choose the advisory or persisted branch.
5. Apply all four lenses to the same direction.
6. Choose exactly one verdict: `proceed`, `revise`, or `pause`.
7. Return the verdict first, then the evidence, required correction, lens trace, and next action.
8. Resume the caller's already-authorized action after `proceed`. After `revise`, carry the correction forward and resume when it stays within existing authority; otherwise ask for the missing decision. Stop only for `pause` or a new authority boundary.

This skill never writes project documentation. The persisted branch writes only its temporary validation artifacts and returns decision wording to the active caller.

## Branches

### Advisory

Use this branch for an automatic checkpoint when a real direction choice is about to harden but the choice and its correction remain cheap to reverse. Skip it when the next move only schedules or executes an already-specified direction.

Apply all four lenses inline. Create no files and use no subagents. Return a compact trace with one line per lens, the exact verdict, and one next action or blocking question.

### Persisted

Use this branch when the user explicitly requests validation or an imminent authorized action is costly or durable.

1. Resolve the OS temporary directory and create the artifact layout below.
2. Write `brief.md` before lens work begins.
3. Choose intensity from residual risk and the depth each lens needs.
4. Load every lens reference and write its expected report. Delegate only independent legwork that could change the verdict; worker count is not an intensity target.
5. Verify `brief.md` and all four reports before writing `verdict.md`. Claim completion only after the full artifact gate passes.

Store artifacts under the OS temporary directory, such as `$TMPDIR` on macOS/Linux or `%TEMP%` on Windows.

## Intensity

Choose intensity after reusing existing evidence. Intensity controls lens depth and evidence legwork:

- `light`: the direction is narrow, evidence is mostly settled, and residual risk is low; keep each lens concise.
- `standard`: meaningful uncertainty remains; inspect the evidence and nearest precedents that could change scope or wording.
- `heavy`: residual risk is broad, high-stakes, or hard to reverse; deepen the load-bearing lenses and add an independent challenge or second pass where useful.

Use subagents only when their source areas or critiques are meaningfully independent. Run the work locally when delegation adds no decision value.

## Lenses

- Evidence: separate facts, constraints, assumptions, inferences, and missing observations. Name the strongest load-bearing uncertainty.
- Precedent: check local language and ownership plus genuinely comparable external precedent. Name intentional breaks.
- Synthesis: test responsibility, boundary, dependency, and invariant coherence. Find the smallest coherent correction.
- Communication: ensure the decision sentence, scope, trade-offs, and operational consequences cause the next reader to act correctly.

For the persisted branch, load every lens reference before running or assigning it:

- Evidence: [references/evidence.md](references/evidence.md)
- Precedent: [references/precedent.md](references/precedent.md)
- Synthesis: [references/synthesis.md](references/synthesis.md)
- Communication: [references/communication.md](references/communication.md)

## Artifact Layout

```text
<os-temp-dir>/validate-direction/<project>/<topic>/
+-- brief.md
+-- reports/
|   +-- evidence.md
|   +-- precedent.md
|   +-- synthesis.md
|   +-- communication.md
+-- verdict.md
```

`brief.md` must contain the direction, absolute `project_root`, lifecycle phase, authorized artifact or action, relevant conversation history, user constraints, reused evidence, load-bearing unknowns, chosen intensity, and every expected report path. Use absolute project file paths throughout the artifacts.

## Artifact Gate

Claim persisted validation complete only when all of these checks pass:

- `brief.md` exists and contains every required field before lens work begins.
- All four expected report paths exist.
- Each report answers its lens, names its strongest objection, and recommends `proceed`, `revise`, or `pause`.
- `verdict.md` exists, reconciles conflicting lens recommendations, and explains any override of the strongest load-bearing objection.
- `verdict.md` contains the exact verdict, key evidence, required changes, risks, wording to carry forward, and one final question only when the verdict is `pause`.

Repair any failed report locally or through a focused follow-up before writing the verdict.

## Verdict

Choose exactly one literal verdict:

- `proceed`: the direction is coherent enough to write or act on.
- `revise`: the direction is sound after a specific scope, boundary, wording, migration, or verification change.
- `pause`: one load-bearing unanswered question could reverse the direction.

Use `revise` when a concrete correction resolves the risk. Use `pause` only when the unanswered question can reverse the decision.

## Output

```md
Verdict: <proceed | revise | pause>

Why:
- ...

Required changes:
- ...

Trace:
- Evidence: ...
- Precedent: ...
- Synthesis: ...
- Communication: ...

Artifacts:
- Brief: <path>
- Verdict: <path>

Next: ...
```

Omit artifact paths for the advisory branch. Ask one blocking question only for `pause`; otherwise state the next authorized action.
