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

**Validation Artifact**:
The installable package source used by a consumer validation run.
_Avoid_: source checkout, branch state

## Relationships

- **Merge Readiness Validation** can use **Consumer-Install Validation** when package consumption is the risk being proven.
- **Merge Readiness Validation** informs merge coordination but does not execute merges.
- A **Pre-Merge Gate** can require **Merge Readiness Validation** before an approved merge command proceeds.
- A **Remote Validation Runner** executes **Consumer-Install Validation** when the local coordinator needs isolated pre-merge evidence.
- A **Validation Scaffold Root** keeps reusable scaffold definitions persistent while each **Merge Readiness Validation** run executes in a fresh per-run workspace.
- A **Validation Artifact** is preferred in this order: `pkg.pr.new`, `pnpm pack`, local workspace path install, then git dependency install.

## Example dialogue

> **Dev:** "Is this PR ready to merge if CI is green?"
> **Domain expert:** "Only after **Merge Readiness Validation** proves the changed package can be consumed through the public install path."

## Flagged ambiguities

- "automatic merging" was used to include both validation and merge execution; resolved: this skill owns **Merge Readiness Validation**, while existing PR coordination skills own merge planning and execution boundaries.
