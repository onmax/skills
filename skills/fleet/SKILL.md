---
name: fleet
description: Converges Linux agent machines into private shared coding nodes and balances bounded agent work across them. Use when bootstrapping or reconciling a VPS, Tailscale access, Docker or Portainer, Codex and GitHub auth profiles, shared workspaces, scheduled jobs, machine cleanup, or distributing coding agents between nodes.
---

# Fleet

Fleet keeps Linux agent nodes boring: separate auth profiles, shared files, `.agents/skills` only, tailnet access, minimal scheduled jobs, and minimal global CLIs.

Use `worktree-cleanup` for repository cleanup and `write-a-skill` for skill edits. Keep host inventory in private operator state; public skills contain roles and checks, not addresses, auth URLs, or credentials.

## Branches

- **Bootstrap** establishes a fresh node from its first trusted SSH session through private access, services, profiles, auth handoff, and shared skills.
- **Reconcile** snapshots an existing node, classifies drift, and repairs only the state that is understood and safe to change.
- **Balance** sends only overflow agent jobs from one coordinator to workers with spare capacity. It uses existing private access and adds no resident scheduler.

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
- Private inventory assigns each node a role, a maximum agent count, and a memory reserve. Public instructions use `coordinator` and `worker`, not host names.
- One coordinator owns discovery and assignment and fills its local agent slots first. Workers execute only overflow jobs in separate checkouts and return a commit plus verification; they do not share a live worktree.

## Node Workflow

Use this workflow for Bootstrap and Reconcile. Balance uses Load Sharing after the participating nodes pass Reconcile.

1. Select the branch and load the matching sections of [REFERENCE.md](REFERENCE.md). The branch is fixed before the first mutation.
2. On bootstrap, compare the provider's purchase record (plan, region, and billing estimate) and the guest's live CPU, memory, disk, and architecture with the user's requested target before naming or changing the node. Stop on any mismatch. Then snapshot users, groups, listeners, firewall, services, timers, crons, packages, disks, active repos, dirty work, Tailscale, and auth presence. Every discovered item is classified as `keep`, `remove`, `archive`, or `needs-user-review` before cleanup begins.
3. Establish trusted access. On bootstrap, install an operator public key, patch the host, create the admin and agent profiles, connect Tailscale, and keep the original session open until a second tailnet SSH session succeeds. Public SSH is restricted only after that proof.
4. Converge machine services. Docker is healthy, Portainer binds only to loopback, and Tailscale Serve is its only remote route. `ss`, `docker ps`, and `tailscale serve status` must all prove the boundary.
5. Converge profiles. Start Codex and GitHub device login for each requested agent user, wait for the user to finish each flow, then verify `codex login status` and `gh auth status` without exposing stored credentials.
6. Converge source. The shared workspace is group-writable and setgid; the skills repo is clean at the exact expected commit; every profile resolves `~/.agents/skills` to that shared tree.
7. Remove classified drift, preserving unique source, SSH material, Tailscale state, provider auth, database volumes, and dirty repositories.
8. Verify the complete node from an agent profile and report changed state, preserved state, private access names, remaining blockers, and exact re-check commands. Completion requires tailnet SSH, private Portainer, Codex status, GitHub status, skills parity, and listener checks to pass.

## Load Sharing

Use Balance only after every participating node passes Reconcile.

1. Read the private role and capacity inventory, then sample active agent count, available memory, CPU pressure, and disk pressure on the coordinator and eligible workers. A node has capacity only when it is below its agent limit and above its memory reserve.
2. Fill the coordinator's configured local agent slots first. When independent jobs remain, delegate them through the existing tailnet SSH or T3 path to workers with free slots and enough memory reserve. If no worker is eligible, wait; do not oversubscribe either host.
3. Send only the repository, exact base or head ref, task boundary, allowed mutations, and required verification. The worker creates its own checkout or worktree and returns the resulting commit, terminal outcome, and verification evidence.
4. Never let two nodes mutate the same branch or worktree. Do not copy provider auth between hosts, migrate a running agent, or run the same watcher on multiple nodes unless its queue has a distributed claim or lease.
5. Re-sample capacity before each dispatch. Keep the policy static and operator-readable; add a daemon, shared queue, or ViteHub primitive only after manual dispatch is the demonstrated bottleneck.

## Mutation Rules

- Preserve dirty Git repos unless the user granted deletion and a clean canonical copy is verified.
- Preserve SSH keys, Tailscale state, Codex auth, provider auth, password material, and database volumes.
- Disable services and timers before deleting their files.
- Archive uncertain user data; delete regenerated caches and build output directly.
- Bind dashboards to loopback or the tailnet. A public listener requires explicit user consent and a named reason.
- Keep addresses, tailnet names, device codes, tokens, and auth files out of repositories and reports.
- Add daemons, timers, dashboards, or wrappers only when they replace more complexity than they add.
- Keep coordinator and capacity assignments in private operator state. Changing a node's role or limit is an explicit operator action.

## Reference

For bootstrap commands, private Portainer, authentication handoff, Tailscale/T3 recipes, capacity checks, bounded delegation, and audits, see [REFERENCE.md](REFERENCE.md).
