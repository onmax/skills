# Pre-Merge Validation Reference

## Remote Layout

Prefer a persistent scaffold root with fresh per-run workspaces:

```text
~/onmax/validation-runners/<owner>/<repo>/
+-- seeds/
+-- runs/
|   +-- pr-<number>-<head-sha>-<timestamp>/
|       +-- summary.md
|       +-- command-log.txt
|       +-- repro/
+-- latest/
    +-- pr-<number>.json
```

Keep only recent runs unless the user asks to preserve a repro.

## Ledger Shape

`latest/pr-<number>.json` should be small and machine-readable:

```json
{
  "repo": "owner/name",
  "pr": 123,
  "headSha": "abc123",
  "verdict": "pass",
  "artifact": {
    "kind": "pkg.pr.new",
    "spec": "https://pkg.pr.new/owner/name/@scope/package@abc123"
  },
  "scenario": "consumer imports package and runs build",
  "runPath": "~/onmax/validation-runners/owner/name/runs/pr-123-abc123-20260523T120000Z",
  "commands": ["pnpm install", "pnpm verify"],
  "createdAt": "2026-05-23T12:00:00Z",
  "summary": "Installed preview package into a fresh consumer project and verified build."
}
```

Use the exact head SHA from `gh pr view` or the merge coordinator. A passing ledger with a different SHA is `stale`.

## Artifact Selection

Choose the first available credible artifact:

1. `pkg.pr.new` preview package from PR body, bot comments, checks, or known workflow output.
2. `pnpm pack` from the exact PR checkout on the VPS.
3. Local workspace path install when publishing or packing is unavailable.
4. Git dependency install when package-manager artifacts are impossible.

Prefer artifacts that exercise the published package `files`, `exports`, generated `dist`, and peer dependency behavior.

## Scenario Selection

Search these sources before inventing a repro:

- prior scaffold seeds under the validation runner
- existing repros such as `~/repros`
- package examples and playgrounds
- docs and quickstarts changed by the PR
- package tests that already reveal the intended public usage
- PR body, issue links, and changed-file names

Then build one primary scenario around the changed consumer behavior. Good proofs are often `typecheck`, `build`, `verify`, `test`, or a focused runtime script.

## Remote Command Pattern

Use `vps-connection` first to discover helpers and verify remote access. When helpers exist, prefer a remote Codex task with an explicit working directory:

```sh
CODEXH_DIR=~/onmax/validation-runners/<owner>/<repo> codexh "Run pre-merge validation for owner/repo PR 123 at <sha> using the attached plan."
```

For deterministic shell steps, plain SSH is acceptable:

```sh
ssh hetzner 'mkdir -p ~/onmax/validation-runners/<owner>/<repo>/runs'
```

Do not print secrets, hidden config, `.env` contents, private keys, or full remote SSH configuration.

## Failure Classification

Classify failures before reporting:

- `fail-repro`: missing peer dependency in the repro, wrong framework version, invalid assertion, bad scaffold, or unrelated setup error that can be corrected inside the repro.
- `fail-pr`: install/export/build/runtime failure caused by the PR artifact in a valid consumer scenario.
- `blocked`: remote access, artifact availability, credentials, registry, network, or external provider infrastructure prevents a credible run.

Only `fail-pr` should route to `pr-refiner`.
