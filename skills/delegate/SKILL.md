---
name: delegate
description: Delegate one conversation-grounded pull request to a separate Codex task.
argument-hint: "<PR title> [host]"
disable-model-invocation: true
---

# Delegate

Turn the current conversation's next coherent pull request into a separate task. The current task owns only the delegation packet, dispatch, and supervision; the created task owns research, implementation, publication, and cleanup.

## Invocation

```text
/delegate <PR title>
/delegate <PR title> <host>
```

Without a host, use the matching local project. With a host such as `h1` or `h2`, use the matching connected project on that host. Treat the title as a proposed PR title that the direction check may tighten.

## Process

1. **Resolve the destination.** Infer one target repository from the conversation, then list Codex projects and select the exact repository on the requested host. If the repository or host is ambiguous, ask one blocking question. If a named host is unavailable, stop and recommend `fleet` for reconciliation instead of dispatching elsewhere. This step is complete when one project and host are fixed.

2. **Build the packet.** Distill the conversation into the template below. Preserve established evidence and decisions instead of reproducing the transcript. Mark missing or stale evidence explicitly. This step is complete when a fresh agent can act without access to the source conversation.

3. **Create the task.** Create a separate Codex task in the destination project's local checkout and pass the packet as its initial prompt. The child must create its own temporary Git worktree, so do not ask Codex to create a managed worktree for the task. Surface the created task immediately. This step is complete when Codex returns the new task identifier and host.

4. **Supervise without duplicating.** Follow the created task with the thread coordination tools. Forward new source context when it changes the work, leave approvals and genuine user choices to the user, and keep implementation out of the source task. This step is complete when the child returns the PR URL and confirms local cleanup, or reports a concrete blocker.

## Delegation Packet

```md
You own one pull request in a separate task.

Proposed PR title: <title>
Target repository: <repository and project root>
Origin: <source task id or title when available>

Goal:
<the outcome and why it belongs in this repository>

Established context:
- <evidence already gathered, with file, commit, PR, URL, or session pointers>
- <decisions already made and rejected alternatives>
- <downstream symptom or motivating use case>

First-PR boundary:
- In scope: <smallest coherent change>
- Out of scope: <adjacent follow-up work>
- Acceptance: <observable proof required before publication>

Constraints:
- <user and repository constraints>
- PR creation is authorized. GitHub comments, issue comments, merges, and deployments require separate authorization.

Execution contract:
1. Reuse the established context. Run evidence-research only for a load-bearing gap, stale claim, or contradiction; record what new evidence changes.
2. Before mutation, use validate-direction and one independent sub-agent to challenge repository ownership, overlap with existing PRs or worktrees, and the smallest coherent first-PR boundary. Resolve every material objection.
3. Preserve the ambient checkout. Refresh the intended base, reconcile existing PR ownership, and create a dedicated temporary worktree from the current upstream base.
4. Implement only the validated boundary and run the repository's relevant tests, checks, and live proof. Use an independent code-review or simplify pass before publication when it can change the diff.
5. Use pr-body for the pull request body. Commit, push, and create one pull request using the repository's conventions.
6. After the pushed commit and PR URL are confirmed, return to the ambient checkout and use worktree-cleanup to remove the temporary worktree, disposable artifacts, and local branch when safe. Preserve the remote PR branch and report the PR URL, validation, and cleanup result.
```

## Boundaries

- One invocation delegates one pull request. Split independent seams into separate invocations.
- The child may deepen prior research, but settled research is reused by default.
- The source task remains a coordinator. All repository mutations happen in the created task's temporary worktree.
- A named host is an exact destination, never a fallback preference.
