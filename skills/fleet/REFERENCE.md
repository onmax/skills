# Fleet Reference

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

Keep T3 reachable through Tailscale only unless the user explicitly asks for public exposure.

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
