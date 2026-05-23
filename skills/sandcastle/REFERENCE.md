# Sandcastle Reference

Last checked against [mattpocock/sandcastle](https://github.com/mattpocock/sandcastle) on 2026-05-23.

## Setup

Use the repository's existing Sandcastle setup when present. For a new setup, start with:

```sh
npx sandcastle init
```

Choose the smallest provider that fits the run. Local Docker or Podman is usually the first option; VPS-backed execution should go through `vps-connection`.

## Onmax VPS Convention

Observed convention:

- Remote repos should mirror local paths, for example `~/vitehub/vitehub` and `~/onmax/skills`.
- A repo may symlink `.sandcastle` to the shared remote directory `~/.agents/sandcastle`.
- The shared Sandcastle directory can contain auth material and environment files. Do not read or print `.env`, `codex-home/`, `auth.json`, `config.toml`, or other credentials.
- ViteHub currently exposes package scripts named `sandcastle` and `sandcastle:build-image`.
- The shared runner uses a Docker sandbox image, a branch strategy with generated `sandcastle/<timestamp>` branches, a prompt file at `./.sandcastle/prompt.md`, and a sandbox setup hook that runs package installation.

For remote execution, inspect only safe metadata first:

```sh
ssh hetzner 'cd ~/vitehub/vitehub && ls -la .sandcastle && git status --short'
ssh hetzner 'cd ~/vitehub/vitehub && node -e "const p=require(\"./package.json\"); console.log(p.scripts?.sandcastle)"'
```

Use `vps-connection` before any remote mutation.

## Prompt Sources

Sandcastle accepts either an inline `prompt` or a `promptFile`, not both.

Prefer `promptFile` for repeatable issue workflows because prompt files support `promptArgs` substitution. `promptFile` resolves against `process.cwd()`, not the run `cwd`.

Built-in prompt arguments:

- `{{SOURCE_BRANCH}}`
- `{{TARGET_BRANCH}}`

Do not pass those names through `promptArgs`; Sandcastle injects them.

## Branch Strategies

- `head`: writes directly to the host working directory. Avoid for autonomous issue execution unless the user explicitly asks.
- `merge-to-head`: works on a temporary branch and merges back to the host branch.
- `branch`: commits land on an explicit branch. Prefer this for issue-driven work and PR creation.

## Completion Signal

The default early-stop marker is:

```text
<promise>COMPLETE</promise>
```

Document this in the prompt when the agent should stop once the issue objective is complete.
