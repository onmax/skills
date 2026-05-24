---
name: vps-connection
description: Helps agents discover, verify, and use the user's VPS/SSH connection, including Codex app SSH connections. Use when the user mentions VPS, SSH, Hetzner, heztner, remote Codex, Codex app SSH, deploy:vps, or asks the agent to connect to a server, explore remote setup, run remote tasks, or debug remote deployment.
---

# VPS Connection

Use this skill to orient safely before doing remote work over SSH. Its purpose is to tell agents how to use the user's SSH/VPS setup, not to document unrelated remote workflows.

## Codex App SSH
Prefer the Codex app's built-in SSH connection when the current thread is already running through one. Continue working in that connected remote environment instead of starting a separate remote Codex process.

Use the pipoyu Codex app SSH account/profile by default for remote Codex work. If the current app SSH connection is not using pipoyu and account identity matters for the task, ask the user to switch the Codex app SSH connection/profile to pipoyu before continuing.

If the Codex app SSH session fails because the active Codex account is rate-limited, quota-limited, or otherwise account-limited, report that the active app SSH account appears limited and ask the user to switch the Codex app SSH connection/profile to pipoyu. After the user switches, continue in the same remote workspace and preserve the current remote path and task context.

## SSH Orientation
Inspect local SSH aliases before connecting:

```sh
awk '/^Host / { print }' ~/.ssh/config
```

Look for project-specific VPS commands when working inside a repo:

```sh
rg -n "deploy:vps|ssh |rsync|docker compose|hetzner|heztner" package.json README.md . --glob '!node_modules/**' --glob '!dist/**' --glob '!*.env'
```

Verify the connection with a harmless command:

```sh
ssh hetzner 'hostname; whoami; pwd'
```

If `hetzner` fails and local SSH config contains `heztner`, retry with that alias. If neither alias exists, inspect the matching `~/.ssh/config` block locally and ask before creating or changing SSH config. Do not paste host IPs, private key paths, usernames, or full SSH config unless the user explicitly needs them.

## Remote Checks
After SSH succeeds, gather only non-secret facts needed for the task:

```sh
ssh hetzner 'hostname; whoami; pwd'
ssh hetzner 'command -v codex && CODEX_HOME=/home/maxi/.codex-pipoyu codex --version'
```

For app repositories, inspect only the relevant app directory and commands discovered from the local repo. Do not assume a default remote app path unless project documentation or the user provides one.

## Troubleshooting
- If the user types `heztner`, check whether SSH config aliases both `hetzner` and `heztner`.
- If remote Codex prints permission warnings, inspect ownership under the relevant `CODEX_HOME`.
- If passwordless sudo is needed for a fix, test it first with `ssh hetzner 'sudo -n true 2>/dev/null && echo sudo-ok || echo sudo-needs-password'`.
- If every SSH command prints shell profile warnings, report the noise separately from command results. Do not edit shell profiles unless the user asks for setup cleanup.

Only change ownership, SSH aliases, Docker state, or remote files when the user has asked for setup/debugging and the evidence points to that exact fix.

## Privacy Rules
- Minimize disclosure in final answers. Say `the Hetzner SSH alias works` instead of repeating IP addresses, key paths, usernames, or home paths unless those details are necessary.
- Redact secrets and private infrastructure details from copied command output.
- Never run broad commands that dump hidden directories, environment variables, shell history, auth files, Codex config, provider tokens, or private keys.
- When searching repos, exclude `.env*`, keys, logs, `node_modules`, build output, and dependency locks unless the user specifically asks to inspect them.

## Safety Rules
- Treat SSH config, shell profiles, and remote homes as user-owned state. Read before editing.
- Prefer the Codex app SSH connection for remote Codex work when the thread is already connected through it.
- Use the pipoyu Codex app SSH account/profile by default for remote Codex work.
- Use plain `ssh hetzner '<command>'` for factual inspection and deployment checks.
- Before running destructive or state-changing remote commands, state what will change.
- Keep remote output compact and relevant; summarize long logs instead of pasting them.
