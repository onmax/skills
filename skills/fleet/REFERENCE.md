# Fleet Reference

Read only the sections needed by the selected `fleet` branch. Vendor installation commands drift; verify them against current official documentation before changing package sources.

## New-node Bootstrap

Before naming or changing a new node, verify the provider's purchased plan, location, billing estimate, CPU, memory, root disk, and architecture against the user's requested target. Then prove the guest resources independently:

```sh
hostname
cat /etc/os-release
uname -m
nproc
free -h
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS
```

Stop and ask the user when the plan label or any resource differs. Successful SSH access proves only that the node is reachable, not that the intended machine was purchased.

Keep the operator home separate from the shared workspace. `/home/workspace` is group-writable source storage, not a user home. A `workspace` operator uses `/home/workspace-operator`; install the operator key there before running bootstrap.

Run the deterministic bootstrap from a temporary public checkout after the provider image accepts the operator's SSH key:

```sh
git clone --depth=1 https://github.com/onmax/skills.git /tmp/onmax-skills
cd /tmp/onmax-skills
bash skills/fleet/scripts/bootstrap-node.sh self-test
sudo ADMIN_USER="$USER" AGENT_USERS="maxi" skills/fleet/scripts/bootstrap-node.sh prepare
```

`prepare` patches Ubuntu, installs Node 24, GitHub CLI, Codex, and UFW, creates the workspace, prepares the requested agent profile, and syncs the public skills repo. It leaves SSH available for the bootstrap session. Omit `AGENT_USERS` to reuse `ADMIN_USER` as the single agent profile.

Prove a second direct key-only SSH session from the operator machine. Then link T3 Connect as the agent user and finish the service and SSH hardening:

```sh
npx t3@latest connect link --headless
sudo ADMIN_USER="$USER" AGENT_USERS="maxi" \
  /tmp/onmax-skills/skills/fleet/scripts/bootstrap-node.sh finish
```

`finish` installs the T3 user service, enables lingering, and disables SSH password and root login. T3 Connect uses its managed outbound relay client; do not open a T3 application port in UFW.

## Private Inventory

Keep provider IDs, public addresses, and SSH aliases in operator-controlled state such as `~/.ssh/config` or a password manager. A public fleet skill records only generic roles and verification commands.

Use a stable provider-based SSH alias so project names can move between nodes:

```sshconfig
Host <provider-sequence-alias>
  HostName <provider-address>
  HostKeyAlias <provider-sequence-alias>
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
npm list -g --depth=0
sudo sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|permitrootlogin) '
npx t3@latest connect status
npx t3@latest service status
```

For Balance, sample capacity without installing an agent or exporter:

```sh
nproc
uptime
grep -E 'MemAvailable|SwapFree' /proc/meminfo
cat /proc/pressure/cpu
cat /proc/pressure/memory
cat /proc/pressure/io
pgrep -af 'codex exec|claude' || true
```

Keep the capacity envelope in private operator state:

```text
role: coordinator | worker
max_agents: <positive integer>
min_available_memory_gib: <positive number>
```

Start conservatively with one agent slot per node. Increase a node's limit only after representative runs stay above its memory reserve without sustained CPU, memory, or I/O pressure.

## Bounded Delegation

The coordinator remains the only process that discovers and assigns shared work. It fills its local agent slots first, then sends each remaining job to an eligible worker as one job envelope:

```text
repository: <clone URL or existing shared-workspace repository>
ref: <exact base or head SHA>
task: <bounded outcome>
mutations: <allowed branches, files, and external actions>
verification: <commands or observable proof>
```

Use existing direct SSH or a verified T3 path. The transport may be simple and interactive; do not add a queue merely to avoid one SSH command.

The worker creates a distinct checkout or worktree, owns the delegated branch until completion, and returns:

```text
outcome: <completed | blocked | failed>
commit: <SHA when code changed>
verification: <results>
blocker: <external condition when blocked>
```

Do not run identical polling schedules on two nodes when they coordinate only through process-local state. Keep one scheduler and distribute execution. A shared queue becomes warranted when the system needs atomic claims, crash recovery, automatic retries, or coordinator failover across hosts.

Check each agent profile without printing secrets:

```sh
for user in maxi; do
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
sudo usermod -aG codex-workspace maxi
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

## SSH And T3 Code

Use official docs or CLI help at execution time because T3 remote commands are moving quickly.

Stable T3 smoke:

```sh
npm view t3 version
npx t3@latest --help
```

Link the browser environment interactively, then install its user service:

```sh
npx t3@latest connect link --headless
npx t3@latest connect status
sudo loginctl enable-linger <agent-user>
npx t3@latest service install
npx t3@latest service status
```

Keep OpenSSH independent from T3 and key-only:

```sh
sudo sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|permitrootlogin) '
systemctl is-active ssh
ufw status verbose
```

The effective SSH values must be `passwordauthentication no`, `kbdinteractiveauthentication no`, `pubkeyauthentication yes`, and `permitrootlogin no`. T3 Connect should show enabled exposure, a provisioned environment link, and an available managed relay client. Any unrelated listener remains workload-specific and must be classified before changing it.

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
systemctl is-active ssh
sudo sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|permitrootlogin) '
npx t3@latest connect status
npx t3@latest service status
ss -lntup
ufw status verbose
git -C /home/workspace/onmax/skills status --short --branch
git -C /home/workspace/onmax/skills rev-parse HEAD
```

Verify every requested agent profile with the auth-presence and skills checks from the snapshot section. Completion requires a second direct SSH session, an installed T3 service with a provisioned relay, and an exact skills commit.

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
Codex auth
provider auth
dirty Git repos
unpushed commits
database volumes
```
