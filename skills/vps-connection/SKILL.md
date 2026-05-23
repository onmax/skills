---
name: vps-connection
description: Helps agents discover, verify, and use the user's VPS/SSH connection and remote Codex helpers. Use when the user mentions VPS, SSH, Hetzner, heztner, remote Codex, codexh, codexh-pipoyu, deploy:vps, or asks the agent to connect to a server, explore remote setup, run remote tasks, or debug remote deployment.
---

# VPS Connection

Use this skill to orient safely before doing remote work over SSH. Prefer discovered local configuration over assumptions.

## Remote Path Shape
Prefer keeping remote repository paths parallel to local paths:
- Local `~/vitehub/...` should map to remote `~/vitehub/...`.
- Local `~/onmax/...` should map to remote `~/onmax/...`.

For Onmax skills, the expected remote setup is:
- Clone `gh:onmax/skills` or `https://github.com/onmax/skills.git` to `~/onmax/skills`.
- If `gh:` shorthand is missing, add `git config --global url.https://github.com/.insteadOf gh:` before using it.
- Link each `~/onmax/skills/skills/<skill-name>` directory into `~/.agents/skills/<skill-name>`.
- Preserve existing non-Onmax skill directories in `~/.agents/skills`.

## First Pass
1. Inspect local SSH aliases and shell helpers before connecting:

```sh
awk '/^Host / { print }' ~/.ssh/config
zsh -ic 'type codexh 2>/dev/null; type codexh-pipoyu 2>/dev/null'
```

2. Look for project-specific VPS commands:

```sh
rg -n "deploy:vps|ssh |rsync|docker compose|CODEXH_DIR|codexh|hetzner|heztner" package.json README.md . --glob '!node_modules/**' --glob '!dist/**' --glob '!*.env'
```

3. Verify the connection with a harmless command:

```sh
ssh hetzner 'hostname; whoami; pwd'
```

If `hetzner` fails and local SSH config contains `heztner`, retry with that alias. If neither alias exists, inspect the matching `~/.ssh/config` block locally and ask before creating or changing SSH config. Do not paste host IPs, private key paths, usernames, or full SSH config unless the user explicitly needs them.

## Known Local Helpers
Expected defaults when present:

- `codexh` uses `CODEX_HOME=/home/maxi/.codex`.
- `codexh-pipoyu` uses `CODEX_HOME=/home/maxi/.codex-pipoyu`.
- `CODEXH_DIR` overrides the remote working directory.
- The common default remote app directory is `/home/maxi/quiver-chat`.

Use `CODEXH_DIR=/remote/path codexh "task"` to override the remote repo. For interactive remote Codex, run `codexh` or `codexh-pipoyu` without arguments.

## Remote Orientation
After SSH succeeds, gather only non-secret facts:

```sh
ssh hetzner 'hostname; whoami; pwd'
ssh hetzner 'command -v codex && CODEX_HOME=/home/maxi/.codex codex --version'
ssh hetzner 'test -d /home/maxi/quiver-chat && cd /home/maxi/quiver-chat && git status --short'
ssh hetzner 'cd /home/maxi/quiver-chat && sudo docker compose ps'
```

Do not print `.env`, private keys, tokens, full Codex configs, full SSH configs, host IPs, usernames, or logs likely to contain secrets. Report that they exist instead.

## Privacy Rules
- Minimize disclosure in final answers. Say `the Hetzner SSH alias works` instead of repeating IP addresses, key paths, usernames, or home paths unless those details are necessary.
- Redact secrets and private infrastructure details from copied command output.
- Never run broad commands that dump hidden directories, environment variables, shell history, auth files, or Codex config.
- When searching repos, exclude `.env*`, keys, logs, `node_modules`, build output, and dependency locks unless the user specifically asks to inspect them.

## Troubleshooting
- If the user types `heztner`, check whether SSH config aliases both `hetzner` and `heztner`.
- If remote Codex prints permission warnings, inspect ownership under the relevant `CODEX_HOME`:

```sh
ssh hetzner 'find /home/maxi/.codex-pipoyu -maxdepth 2 \( ! -user maxi -o ! -group maxi \) -printf "%M %u %g %p\n" 2>/dev/null | sort | sed -n "1,80p"'
```

- If passwordless sudo is needed for a fix, test it first:

```sh
ssh hetzner 'sudo -n true 2>/dev/null && echo sudo-ok || echo sudo-needs-password'
```

Only change ownership, SSH aliases, helper functions, Docker state, or remote files when the user has asked for setup/debugging and the evidence points to that exact fix.

## Safety Rules
- Treat SSH config, shell profiles, and remote homes as user-owned state. Read before editing.
- Never expose secrets from `.env`, private keys, Codex auth/config files, shell history, or provider tokens.
- Prefer `codexh`/`codexh-pipoyu` for sending remote Codex tasks when the helpers exist.
- Use plain `ssh hetzner '<command>'` for factual inspection and deployment checks.
- Before running destructive or state-changing remote commands, state what will change.
- Keep remote output compact and relevant; summarize long logs instead of pasting them.
