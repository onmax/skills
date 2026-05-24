---
name: vps-connection
description: Helps agents discover, verify, and use the user's VPS/SSH connection. Use when the user mentions VPS, SSH, Hetzner, heztner, deploy:vps, or asks the agent to connect to a server, explore remote setup, run remote tasks, or debug remote deployment.
---

# VPS Connection

Use this skill to orient safely before doing remote work over SSH. Its purpose is to tell agents how to use the user's SSH/VPS setup, not to document Codex accounts, profiles, billing, or unrelated remote workflows.

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
```

For app repositories, inspect only the relevant app directory and commands discovered from the local repo. Do not assume a default remote app path unless project documentation or the user provides one.

## Shared Workspace
The expected shared project root is `/home/workspace`. Account-specific SSH users should use shared repositories there instead of cloning duplicate repositories under their own home directories.

When working in a shared repository, verify the SSH user can read Git metadata before doing PR or branch work:

```sh
ssh heztner-pipoyu 'id; cd /home/workspace/vitehub/vitehub && git status --short --branch'
```

If `id` does not include `codex-workspace`, or Git files under `/home/workspace/.../.git` are not readable, fix the shared workspace setup before continuing. If Git reports dubious ownership, add the shared repo as a safe directory for each account user that uses it:

```sh
ssh hetzner 'for u in maxi-main maxi-pipoyu maxi-onmax; do sudo -u "$u" git config --global --add safe.directory /home/workspace/vitehub/vitehub; done'
```

Do not work around shared workspace permission problems by cloning a second copy of the same repo under `/home/<account-user>/...`; that hides the setup issue and fragments active work.

## Troubleshooting
- If the user types `heztner`, check whether SSH config aliases both `hetzner` and `heztner`.
- If passwordless sudo is needed for a fix, test it first with `ssh hetzner 'sudo -n true 2>/dev/null && echo sudo-ok || echo sudo-needs-password'`.
- If every SSH command prints shell profile warnings, report the noise separately from command results. Do not edit shell profiles unless the user asks for setup cleanup.

Only change ownership, SSH aliases, Docker state, or remote files when the user has asked for setup/debugging and the evidence points to that exact fix.

## Privacy Rules
- Minimize disclosure in final answers. Say `the Hetzner SSH alias works` instead of repeating IP addresses, key paths, usernames, or home paths unless those details are necessary.
- Redact secrets and private infrastructure details from copied command output.
- Never run broad commands that dump hidden directories, environment variables, shell history, auth files, provider tokens, or private keys.
- When searching repos, exclude `.env*`, keys, logs, `node_modules`, build output, and dependency locks unless the user specifically asks to inspect them.

## Safety Rules
- Treat SSH config, shell profiles, and remote homes as user-owned state. Read before editing.
- Use plain `ssh hetzner '<command>'` for factual inspection and deployment checks.
- Before running destructive or state-changing remote commands, state what will change.
- Keep remote output compact and relevant; summarize long logs instead of pasting them.
