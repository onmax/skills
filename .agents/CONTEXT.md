# Onmax Skills

Vocabulary for agent skills that coordinate repository work, pull requests, and merge readiness.

## Language

**Merge Readiness Validation**:
A pre-merge evidence pass that proves a pull request's changed consumer-facing behavior with the cheapest credible checks.
_Avoid_: automatic merging, generic testing, E2E-only testing

**Consumer-Install Validation**:
A validation style that tests a pull request by installing its package artifact into an external consumer project.
_Avoid_: repository-internal-only validation, implementation test

**Pre-Merge Gate**:
A final condition checked immediately before merge execution to catch unresolved readiness risk.
_Avoid_: development workflow, continuous test suite

**Remote Validation Runner**:
A VPS-backed execution environment used to run pre-merge validation away from the local worktree.
_Avoid_: local-only validation, CI replacement

**Validation Scaffold Root**:
A persistent remote directory that stores reusable consumer-project templates and isolated per-run workspaces.
_Avoid_: shared mutable test app, one-off temp directory only

**Dynamic Consumer Repro**:
A generated minimal consumer project shaped by the pull request's changed behavior and the target repository's usage examples.
_Avoid_: fixed scaffold catalog, generic smoke app

**Scaffold Seed**:
A preserved consumer repro that can initialize future validation runs for similar package or behavior changes.
_Avoid_: mandatory fixture, permanent test suite

**Validation Repro Failure**:
A failed validation run whose cause is still being separated between an invalid repro and a real pull request defect.
_Avoid_: confirmed product bug, CI failure

**Validation Ledger**:
A remote record of validation runs keyed by pull request and head commit.
_Avoid_: PR comment log, CI status replacement

**Post-Merge Consumer Defect**:
A bug discovered only after merging because the package fails in a real consumer scenario despite passing repository-local checks.
_Avoid_: ordinary CI failure, internal unit failure

**Validation Artifact**:
The installable package source used by a consumer validation run.
_Avoid_: source checkout, branch state

**Validation Verdict**:
The outcome returned by pre-merge validation for a pull request head commit.
_Avoid_: test result, CI status

## Relationships

- **Merge Readiness Validation** can use **Consumer-Install Validation** when package consumption is the risk being proven.
- **Merge Readiness Validation** informs merge coordination but does not execute merges.
- A **Pre-Merge Gate** can require **Merge Readiness Validation** before an approved merge command proceeds.
- A **Remote Validation Runner** executes **Consumer-Install Validation** when the local coordinator needs isolated pre-merge evidence.
- A **Validation Scaffold Root** keeps reusable scaffold definitions persistent while each **Merge Readiness Validation** run executes in a fresh per-run workspace.
- **Consumer-Install Validation** uses a **Dynamic Consumer Repro** unless a project has deliberately promoted a stable fixture.
- A **Dynamic Consumer Repro** may be discarded, kept as evidence, promoted to a **Scaffold Seed**, or recommended as a repo fixture.
- A **Dynamic Consumer Repro** is seeded from existing repros, examples, docs, playgrounds, or prior scaffold seeds before inventing a new scenario.
- A **Pre-Merge Gate** usually validates one primary **Dynamic Consumer Repro** unless independent consumer surfaces justify additional probes.
- A **Validation Repro Failure** can be debugged by the validation skill until it is classified; confirmed pull request defects are handed to `pr-refiner`.
- A **Validation Ledger** lets `pr-stack-coordinator` decide whether the **Pre-Merge Gate** is current for a pull request head commit.
- **Pre-Merge Gate** validation exists to reduce **Post-Merge Consumer Defects**.
- A **Validation Artifact** is preferred in this order: `pkg.pr.new`, `pnpm pack`, local workspace path install, then git dependency install.
- A **Validation Verdict** is one of `pass`, `fail-pr`, `fail-repro`, `stale`, `skip`, or `blocked`.

## Example dialogue

> **Dev:** "Is this PR ready to merge if CI is green?"
> **Domain expert:** "Only after **Merge Readiness Validation** proves the changed package can be consumed through the public install path."

## Flagged ambiguities

- "automatic merging" was used to include both validation and merge execution; resolved: this skill owns **Merge Readiness Validation**, while existing PR coordination skills own merge planning and execution boundaries.
