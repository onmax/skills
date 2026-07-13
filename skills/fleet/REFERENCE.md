# Fleet Reference

Read only the sections needed by the selected `fleet` branch. Vendor installation commands drift; verify them against current official documentation before changing package sources.

## New-node Bootstrap

Run the deterministic bootstrap from a temporary public checkout after the provider image accepts the operator's SSH key:

```sh
git clone --depth=1 https://github.com/onmax/skills.git /tmp/onmax-skills
cd /tmp/onmax-skills
sudo ADMIN_USER="$USER" AGENT_USERS="maxi-main" skills/fleet/scripts/bootstrap-node.sh prepare
```

`prepare` patches Ubuntu, installs the base CLIs, Docker, Tailscale, and UFW, creates the workspace and agent profiles, stages Portainer, and syncs the public skills repo. It leaves public SSH available for the bootstrap session.

Complete the interactive Tailscale login, prove a second SSH session through the tailnet, then finish private services:

```sh
sudo tailscale up --ssh --operator="$USER"
sudo ADMIN_USER="$USER" AGENT_USERS="maxi-main" LOCK_PUBLIC_SSH=1 \
  /tmp/onmax-skills/skills/fleet/scripts/bootstrap-node.sh finish
```

Use `LOCK_PUBLIC_SSH=1` only while a working tailnet SSH session is open. `finish` starts Portainer on `127.0.0.1:9443`, configures Tailscale Serve, and removes the public UFW SSH allowance when requested.

## Private Inventory

Keep provider IDs, public addresses, tailnet names, and SSH aliases in operator-controlled state such as `~/.ssh/config` or a password manager. A public fleet skill records only generic roles and verification commands.

Prefer an SSH alias that resolves through MagicDNS after bootstrap:

```sshconfig
Host <private-alias>
  HostName <magicdns-name>
  User <agent-user>
  IdentityFile <operator-private-key-path>
  IdentitiesOnly yes
```

The private key path and concrete host values stay outside the repository.

## Snapshot Commands

```sh
hostname
cat /etc/os-release
id
getent passwd
getent group
df -h /
du -h -d1 /home 2>/dev/null | sort -h
systemctl list-timers --all --no-pager
systemctl list-unit-files --no-pager
crontab -l
tailscale status
tailscale ip
docker system df
npm list -g --depth=0
```

Check each agent profile without printing secrets:

```sh
for user in maxi-main maxi-pipoyu maxi-onmax; do
  sudo -u "$user" bash -lc '
    whoami
    test -f ~/.codex/auth.json && echo codex-auth-present || echo codex-auth-missing
    find ~/.agents/skills -maxdepth 1 -mindepth 1 2>/dev/null | wc -l
  '
done
```

## Workspace Shape

Use one shared workspace for source:

```sh
sudo groupadd -f codex-workspace
sudo install -d -o workspace -g codex-workspace -m 2775 /home/workspace
sudo usermod -aG codex-workspace maxi-main
sudo usermod -aG codex-workspace maxi-pipoyu
sudo usermod -aG codex-workspace maxi-onmax
sudo find /home/workspace -type d -exec chmod g+rwxs {} +
sudo find /home/workspace -type f -exec chmod g+rw {} +
```

Prefer shell profile lines that set `umask 002` for agent users so new files remain group-writable.

## Skills Shape

Canonical install target:

```text
/home/<agent-user>/.agents/skills
```

Avoid duplicate user-facing skills in:

```text
/home/<agent-user>/.codex/skills
/home/<agent-user>/onmax/skills
```

Codex may keep internal system files under `.codex`; do not delete auth or Codex-owned system state just to remove skill duplication.

## Claude Code Shape

Canonical `~/.claude/settings.json` baseline for agent profiles (merge into existing settings, do not replace the file):

```json
{
  "permissions": {
    "deny": ["EnterPlanMode", "ExitPlanMode", "DesignSync", "NotebookEdit", "SendMessage", "PushNotification", "RemoteTrigger", "ReportFindings", "ScheduleWakeup", "AskUserQuestion", "CronCreate", "CronDelete", "CronList"]
  },
  "disableBundledSkills": true,
  "disableWorkflows": true,
  "disableRemoteControl": true,
  "disableClaudeAiConnectors": true,
  "disableArtifact": true
}
```

## Tailscale And T3 Code

Use official docs or CLI help at execution time because T3 remote commands are moving quickly.

Stable T3 smoke:

```sh
npm view t3 version
npx t3@latest --help
```

Remote pattern to verify when available:

```sh
npx t3@nightly serve --help
```

Tailscale health:

```sh
tailscale version
tailscale status
tailscale ip -4
systemctl is-active tailscaled
```

Tailnet-only Portainer:

```sh
docker ps --filter name=^/portainer$
ss -lntp | grep ':9443 '
tailscale serve --https=443 https+insecure://127.0.0.1:9443
tailscale serve status
```

The listener check must show `127.0.0.1:9443`, never `0.0.0.0`, `[::]`, or the public address. Port `8000` is omitted unless Edge Agents are explicitly required.

Keep T3 reachable through Tailscale only unless the user explicitly asks for public exposure.

## Authentication Handoff

Run authentication inside each agent profile. Device flows are interactive; the operator finishes them in a browser while the command remains attached to that profile.

```sh
sudo -iu <agent-user> codex login --device-auth
sudo -iu <agent-user> gh auth login --web --git-protocol https --skip-ssh-key
```

Verify state without reading stored tokens:

```sh
sudo -iu <agent-user> codex login status
sudo -iu <agent-user> gh auth status
sudo -iu <agent-user> test -f ~/.codex/auth.json
```

Each profile performs its own login. Auth directories and tokens are never copied between users or committed to the shared workspace.

## Bootstrap Verification

```sh
systemctl is-active docker tailscaled ssh
tailscale status
tailscale ip -4
tailscale serve status
docker ps --filter name=^/portainer$
ss -lntup
ufw status verbose
git -C /home/workspace/onmax/skills status --short --branch
git -C /home/workspace/onmax/skills rev-parse HEAD
```

Verify every requested agent profile with the auth-presence and skills checks from the snapshot section. Completion requires no public Portainer listener, a working tailnet SSH session, and an exact skills commit.

## Remove Classes

Usually safe to delete after snapshot:

```text
node_modules
.pnpm-store
.npm/_cacache
.cache
dist
build
.output
.next
.nuxt
.vite
coverage
tmp
.tmp
old logs
duplicate generated worktrees
```

Never delete automatically:

```text
~/.ssh
tailscale state
Codex auth
provider auth
dirty Git repos
unpushed commits
database volumes
```
