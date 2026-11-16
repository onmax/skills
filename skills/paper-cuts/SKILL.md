---
name: paper-cuts
description: Use before ending a turn in which you hit a paper cut: a bug or gap in a library or tool we use, a surprise on the machine, or something you were blocked from doing.
---

# Paper cuts

A **paper cut** is friction you hit along the way that sits outside the task. The user decides what happens to each one; your job is to notice it, look a little, and report it.

## Kinds

- **Library**: a bug, missing feature, awkward API, wrong docs, or unhelpful error in a dependency, framework, CLI, or service we use, the user's own libraries included.
- **Machine**: the machine behaved in a way you didn't expect: a missing binary, a wrong version, a permission, a full disk, a killed process, a busy port, stale config.
- **Blocked**: something you wanted to do and couldn't: a denied tool call, a missing credential or integration, an unreachable host, a sandbox limit.

When you hit one, work around it if you can, note it, and carry on with the task. The fix, the issue, or the config change waits for the user's call.

## Look a little

Spend a few lookups per cut, enough to fill its card:

- **Library**: the installed version from the lockfile, a search of the upstream issues, and the changelog or releases since that version.
- **Machine**: the command and its output, the likely cause, and whether the machine's notes already cover it.
- **Blocked**: the exact error or denial, and what would unblock it: a permission, an integration, a machine change.

Stop once you can say whether it's known and what you'd propose. Deeper research waits until the user asks for it.

## Report

End the turn's final reply with a `Paper cuts` section after the task's own report. Report each cut once per session, even if you hit it again; leave the section out when there are none.

```md
## Paper cuts

**1. <library@version or machine>: <what happened, in one line>**
- Seen: <the command, error, or behavior, with file:line where it applies>
- Found: <what the look turned up, with links: an open issue, fixed in vX, nothing upstream>
- Proposal: <what we could do: upstream issue or PR, workaround, machine change, a note for the machine's docs>

Reply with a number and what to do: research more, open an issue, fix it, or drop it.
```

## When the user decides

- **Research more**: use the `research` skill and bring back the answer as an updated card.
- **Open an issue**: write it on the upstream repo with the version, a minimal reproduction, and links to related issues. Open it and reply with the link.
- **Fix it**: for a library, a patch or PR as the user says; for the machine, make the change and record any lasting fact in the machine's notes.
