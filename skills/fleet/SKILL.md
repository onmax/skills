---
name: fleet
description: Converges Linux agent machines toward a clean shared remote coding node. Use when working on fleet, Linux dev boxes, Tailscale/T3 Code remote access, Codex profile standardization, shared workspaces, cron reduction, or VPS cleanup.
---

# Fleet

Fleet keeps Linux agent nodes boring: separate auth profiles, shared files, `.agents/skills` only, Tailscale/T3 remote access, minimal crons, and minimal global CLIs.

Use `worktree-cleanup` for Git worktrees, stale branches, generated artifacts, or broad repo cleanup. Use `write-a-skill` for skill edits. Do not copy, print, or merge secrets between profiles.

## Desired State

- One admin user owns machine maintenance; agent users own provider auth.
- Agent users write repos and worktrees under one shared workspace.
- Agent user homes keep only auth, shell config, caches, and profile state.
- Skills install into `~/.agents/skills`; do not maintain duplicate `.codex/skills` skill trees.
- Remote access is private by default: Tailscale first, public ports only with explicit user consent.
- Scheduled jobs are exceptional. Keep OS maintenance timers; remove stale app, sync, export, and cleanup crons.
- Global CLIs are limited to machine primitives and tools that cannot reasonably be project-local.
- Claude Code profiles carry the baseline `~/.claude/settings.json` from [REFERENCE.md](REFERENCE.md): interactive/remote tools denied, bundled skills/workflows/remote control/connectors/artifact disabled.

## Workflow

1. Snapshot before mutation: users, groups, workspace permissions, crons, timers, services, package managers, global CLIs, Tailscale status, T3 command help, active repos, dirty work, disk usage, and auth presence without reading secret contents.
2. Classify every item as `keep`, `remove`, `archive`, or `needs-user-review`. Anything with unique source changes or auth material is not deleted.
3. Converge workspace permissions: shared group, setgid directories, writable repos, and a shell umask that lets agent profiles edit the same files.
4. Converge profiles: auth stays per user; skills point to `.agents/skills`; generated files and worktrees go under the shared workspace.
5. Remove drift: dead services, app crons, duplicate skill trees, stale project folders, generated dependency/build folders, old logs, unused CLIs, and caches.
6. Verify remote coding: Tailscale is healthy, the node is reachable by MagicDNS or tailnet IP, T3 Code can start, Codex auth is present for the selected profile, and access does not require a public port.
7. Report what changed, what was deliberately preserved, remaining blockers, and the exact commands a future agent should use to re-check the node.

## Mutation Rules

- Stop and preserve dirty Git repos unless the user already granted aggressive deletion and there is a clean canonical copy.
- Never delete SSH keys, Tailscale state, Codex auth, provider auth, or password/key material.
- Disable services and timers before deleting their files.
- Prefer archive-before-delete only for user data or uncertain service state; delete generated files directly.
- Do not add new daemons, crons, README files, dashboards, or wrappers unless they replace more complexity than they add.

## Reference

For current Tailscale/T3 command recipes and audit commands, see [REFERENCE.md](REFERENCE.md).
