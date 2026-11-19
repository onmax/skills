---
name: boil-the-ocean
description: Use for any big task, one that spans many files, steps, or sessions or would take a person days or more, and whenever you are tempted to cut scope or leave part of a task for later.
---

# Boil the ocean

Deliver the whole request, and spend as little as it takes. Current models do in hours what used to take a team months, as long as every step is checked, so size is no reason to make a task smaller. Tokens are the cost: every round should move the check, and work that only repeats earlier work stops.

## Keep the full scope

Write the request as one sentence at its full size: the **scope sentence**. Measure every plan, brief, and report against it until the end.

Keep the plan outside your context, where it survives compaction and subagents. Before building, put it on a page every worker and the user can read: the scope sentence on top, then every unit with its check and status. Update it in place as units land, give every worker the link, and read the user's comments on it. Without such a page, keep the plan in a file under `/tmp`. A unit leaves the plan only as done or as stopped by a real blocker.

Scope shrinks quietly as context fills. When your draft says "for v2", "for now", "start simpler", "out of scope", "a follow-up", "phase 2", or picks an approach because it is easier, put the cut part back.

Only a real blocker removes part of the request: law, a license, security, safety, money nobody approved, a limit the user set, or a step that needs the user in person (a passkey, a 2FA code, a payment). Anything else that looks too hard is an old cost estimate: check the repository, docs, or tools, and if nothing real comes back, it stays in. Pick whatever stack reaches the goal fastest for agents.

Scope also grows quietly. A unit belongs in the plan when the scope sentence needs it. An idea it doesn't need (a new feature, another sweep, a nicer version of a unit that passes) goes on the plan page under "Later" and into the final report, and stays out of the build.

## Coordinate, don't implement

Your session coordinates: it holds the scope sentence, the plan, and the check, and subagents build the units. Implementing fills your context, and a full context is where scope shrinks.

- **Fable 5.2 plans and steers.** It drafts the plan and reviews progress at every checkpoint. Claude Code: `Agent` with `model: "fable"`, `effort: "high"`, `subagent_type: "general-purpose"`, `run_in_background: false`. Make one Fable call per planning step or checkpoint; Fable's usage limit is tighter than Opus's. If the call fails, do that step yourself and say so in one line.
- **Opus 5.5 builds.** Workers run Opus 5.5 at high effort (medium for mechanical units) unless the user names another model. Claude Code: `Agent` with `model: "opus"` and `effort`.
- Each worker brief carries the scope sentence, one unit, the check that proves it done, the files to read, and the plan link. The worker finishes the unit whole or reports a blocker; it never ships a smaller unit. It replies in under 150 words: the result, the check's output, the PR or commit, and any blocker. Batch small units of the same kind into one worker.
- A **round** is one wave of up to 3 workers running at once. A worker that writes alongside other writers gets its own worktree.
- Rerun the check yourself on every returned unit. A unit that came back smaller goes back out once. A unit that fails its check twice waits for the next checkpoint instead of a third attempt.

## Steps

1. **Scope and blockers.** Write the scope sentence. List every reason the task might be impossible, check each, keep only real blockers.
   Done when each kept blocker is backed by something you checked.
2. **Check.** Find what proves the work right (a reference implementation, tests, a spec, known-good outputs, a benchmark) and turn it into a check with the first four steps of `check-your-work`. If none exists, building one is the first unit.
   Done when the check runs, has gone red on a broken version, and has a baseline.
3. **Plan.** Brief Fable with the scope sentence, the blockers, the check and its baseline, the user's words, and the paths to read. Ask it for every unit the scope sentence needs, each with its check, the order of the rounds, which units can share a worker, and the point where the work is done. Correct anything you can disprove by checking (a file that doesn't exist, a test that already passes), then publish the plan.
   Done when the plan page lists every unit and a worker could start any unit from its brief alone.
4. **Build.** Send out units a round at a time, verify each, keep what passes, send back what fails. Throwaway code is cheap: comparison scripts, parallel attempts where most get deleted. Compare against the real thing, list every known difference from the reference, and get a review from another model family for risky changes. After every 2 rounds, hold a checkpoint.
   Done when every unit has passed its check or is stopped by a real blocker.
5. **Finish.** Do the remaining authorized work yourself (the push, the PR) instead of offering it.
   Done when only real blockers are left.

## Checkpoint

Every 2 rounds, give Fable the plan link, the scope sentence, and each unit's status with its check output since the last checkpoint. Ask:

> Audit this progress against the scope sentence. Which units are done and should stay closed? Which work is going in circles: the same unit retried, review or test rounds that keep finding small things, fixes that undo earlier fixes? Which planned units does the scope sentence not need? What should the next 2 rounds be, or is the work done? Be decisive. Read whatever you need; edit nothing. Dropping part of the scope sentence needs a real blocker (law, license, security, safety, unapproved money, a user limit, a step needing the user in person); name it if you drop something.

Adopt the answer: update the plan page, close what Fable closed, and send out the rounds it named. Overrule it only on a fact you checked, and note on the plan page what you checked. When Fable says the work is done, go to Finish.

Hold an extra checkpoint before a third review or test round on the same PR, and when the plan has grown past what the scope sentence asks.

## Reporting to the user

Write about the task in plain words, and keep the blocker sorting to yourself. Say "Publishing to the App Store needs Xcode, and neither Mac has it", with no oceans, walls, habits, or boiling in messages, plans, or PRs. End without a menu of options or a "should I…?" about work inside the request.

The final report links the plan page and says what the check confirmed, what you couldn't verify (hardware, secrets, judgment calls), the risks of shipping, each real blocker with the one thing the user has to do about it, and the "Later" list.
