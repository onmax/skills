# Cartesian Method and the Boundary Between Knowledge and Illusion

## Purpose

This reference gives conceptual grounding for the Descartes planning foundation ledger. It is not required for normal use. Load it only when the user asks why the skill works this way or wants the Descartes theory behind it.

## Core Idea

The operational lesson from Descartes is not to prove certainty in the historical sense. The useful engineering lesson is assent control: do not treat a claim as established when the available evidence does not support it.

For a planning foundation ledger, this means separating:

- what is directly supported,
- what is inferred,
- what is unknown,
- and what the plan would need in order to rely on a claim safely.

## Methodic Doubt

Methodic doubt is a disciplined way to test whether a belief is strong enough to support further reasoning.

For this skill, methodic doubt is the conceptual background for the planning foundation ledger:

1. Identify the claims the plan depends on.
2. Ask which claims are directly supported.
3. Suspend unsupported claims instead of smuggling them into the plan.
4. Define the minimum evidence needed to upgrade weak claims.

## Appearance vs Judgment

A fluent statement can appear reliable without being supported. Descartes' distinction between appearance and judgment maps well to AI work:

- Appearance: the model can produce a plausible sentence.
- Judgment: the assistant decides whether it is entitled to assert that sentence.

The skill focuses on judgment. It requires evidence traces before a claim can become a foundation in the planning foundation ledger.

## Foundations and Superstructure

A planning foundation ledger separates a foundation layer from a derived plan layer.

Foundation layer:

- verified repo facts,
- observed tool outputs,
- explicit user goals,
- explicit user constraints.

Derived layer:

- proposed implementation steps,
- tradeoffs,
- sequencing,
- risks,
- recommendations.

The derived layer may use inference, but it should not hide inference as fact.

## Practical Translation

| Cartesian idea | Planning foundation ledger behavior |
|---|---|
| Withhold assent where doubt remains | Do not assert unsupported claims as facts. |
| Examine foundations before rebuilding | Inspect prompt, files, configs, and tool outputs before planning. |
| Separate clear perception from judgment | Separate generated plausibility from evidence-backed claims. |
| Error comes from judgment outrunning evidence | Mark assumptions before they become plan dependencies. |

## Recommended Reading Labels

These labels are useful if the user wants deeper philosophical grounding. They are intentionally plain text, not embedded citation artifacts.

- Rene Descartes, *Discourse on the Method*.
- Rene Descartes, *Meditations on First Philosophy*.
- Rene Descartes, *Principles of Philosophy*.
- Stanford Encyclopedia of Philosophy entries on Descartes, skepticism, foundationalism, reliabilism, and brains in vats.

## Use In The Skill

Do not quote this file by default. Use it to explain the rationale behind the planning foundation ledger when asked.
