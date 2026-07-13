---
name: fleet
description: Converges Linux agent machines into private shared coding nodes. Use when bootstrapping or reconciling a VPS, Tailscale access, Docker or Portainer, Codex and GitHub auth profiles, shared workspaces, scheduled jobs, or machine cleanup.
---

# Fleet

Fleet keeps Linux agent nodes boring: separate auth profiles, shared files, `.agents/skills` only, tailnet access, minimal scheduled jobs, and minimal global CLIs.

Use `worktree-cleanup` for repository cleanup and `write-a-skill` for skill edits. Keep host inventory in private operator state; public skills contain roles and checks, not addresses, auth URLs, or credentials.

## Branches

- **Bootstrap** establishes a fresh node from its first trusted SSH session through private access, services, profiles, auth handoff, and shared skills.
- **Reconcile** snapshots an existing node, classifies drift, and repairs only the state that is understood and safe to change.

## Desired State

- One admin user owns machine maintenance; agent users own provider auth.
- Agent users write repos and worktrees under one shared workspace.
- Agent user homes keep only auth, shell config, caches, and profile state.
- Skills install into `~/.agents/skills`; do not maintain duplicate `.codex/skills` skill trees.
- Tailscale carries SSH and web access. Portainer listens on loopback and reaches the user through Tailscale Serve.
- Persistent auth is created interactively inside each profile and verified by status or file presence without reading its contents.
- Scheduled jobs are exceptional. Keep OS maintenance timers; remove stale app, sync, export, and cleanup crons.
- Global CLIs are limited to machine primitives and tools that cannot reasonably be project-local.
- Claude Code profiles carry the baseline `~/.claude/settings.json` from [REFERENCE.md](REFERENCE.md): interactive/remote tools denied, bundled skills/workflows/remote control/connectors/artifact disabled.

## Workflow

1. Select the branch and load the matching sections of [REFERENCE.md](REFERENCE.md). The branch is fixed before the first mutation.
2. Snapshot users, groups, listeners, firewall, services, timers, crons, packages, disks, active repos, dirty work, Tailscale, and auth presence. Every discovered item is classified as `keep`, `remove`, `archive`, or `needs-user-review` before cleanup begins.
3. Establish trusted access. On bootstrap, install an operator public key, patch the host, create the admin and agent profiles, connect Tailscale, and keep the original session open until a second tailnet SSH session succeeds. Public SSH is restricted only after that proof.
4. Converge machine services. Docker is healthy, Portainer binds only to loopback, and Tailscale Serve is its only remote route. `ss`, `docker ps`, and `tailscale serve status` must all prove the boundary.
5. Converge profiles. Start Codex and GitHub device login for each requested agent user, wait for the user to finish each flow, then verify `codex login status` and `gh auth status` without exposing stored credentials.
6. Converge source. The shared workspace is group-writable and setgid; the skills repo is clean at the exact expected commit; every profile resolves `~/.agents/skills` to that shared tree.
7. Remove classified drift, preserving unique source, SSH material, Tailscale state, provider auth, database volumes, and dirty repositories.
8. Verify the complete node from an agent profile and report changed state, preserved state, private access names, remaining blockers, and exact re-check commands. Completion requires tailnet SSH, private Portainer, Codex status, GitHub status, skills parity, and listener checks to pass.

## Mutation Rules

- Preserve dirty Git repos unless the user granted deletion and a clean canonical copy is verified.
- Preserve SSH keys, Tailscale state, Codex auth, provider auth, password material, and database volumes.
- Disable services and timers before deleting their files.
- Archive uncertain user data; delete regenerated caches and build output directly.
- Bind dashboards to loopback or the tailnet. A public listener requires explicit user consent and a named reason.
- Keep addresses, tailnet names, device codes, tokens, and auth files out of repositories and reports.
- Add daemons, timers, dashboards, or wrappers only when they replace more complexity than they add.

## Reference

For bootstrap commands, private Portainer, authentication handoff, Tailscale/T3 recipes, and audits, see [REFERENCE.md](REFERENCE.md).
