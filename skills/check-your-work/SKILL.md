---
name: check-your-work
description: Use before fixing a bug, adding a feature, refactoring, porting, or speeding up code, or when asked to verify a change, prove it works, or keep going until it passes.
---

# Check your work

Reading code finds few bugs. Running it finds most. So every change you hand back has passed a **check**: one command that says how close the work is to done. You set the check before you change anything, and from then on the check decides, not your sense that a change "obviously" works.

For a task too big to hold in one sitting, such as a rewrite or a port, start with `boil-the-ocean`. It sizes the work and cuts it into units. This skill is how you finish each unit.

## Steps

1. **Set the check.** Pick one command and the bar that means done: tests pass, the output matches a reference, the build takes under 20 seconds. Prefer an exact check (matches, failing-test count) over a clock. For a bug, write the test that reproduces it first, from the bug report, before any fix. Also pick **guards**: the commands for what you weren't asked to change, like the old tests and the typecheck.
   Done when the check, the bar, and the guards are written in your notes.

2. **Ready the environment.** Run the check where the code runs, as described in **Environment** below.
   Done when the check and the guards run, you have written down the baseline, and the commands that bring the environment up are in your notes.

3. **Make the check go red.** Break the code on purpose and run the check. Then restore the code and run it again. A check that stays green on broken code checks nothing.
   Done when you have seen the check red on the broken version and back to its baseline after the restore.

4. **Freeze the check.** List the check files: tests, fixtures, the benchmark, the reference outputs, the test-runner config. Note the commit you start from. These files stay as they are while you work. If the check itself turns out to be wrong, stop, say why, and fix it as its own step with its own commit.
   Done when the list and the start commit are in your notes.

5. **Climb.** Repeat until you reach the bar or stall:
   - Make one change for one reason, and guess its effect first. A guess that is far off means your picture of the code is wrong, so look closer before the next change.
   - Run the check and the guards.
   - Confirm the check is untouched: `git diff --quiet <start> -- <check files> || echo "CHECK CHANGED"`.
   - Better and every guard green: commit, with the idea as the message. Otherwise undo the change fully (`git restore . && git clean -fd` for files you added) and move on.
   - Log each try in one line on disk (idea, score, kept or undone), so a restart or a compacted context doesn't retry dead ideas.
   Done when the check meets the bar, or after five tries in a row with no gain. On a stall, find out why before trying more: profile, make the check finer, or ask whether the approach can reach the bar at all.

6. **Hand back.** Read the whole diff from the start commit as one piece. Look for removed tests, swallowed errors, a feature switched off, or a changed default. Rerun the check and the guards on the final code, and quote their output.
   Done when your report shows the baseline, the measured result, the environment it ran in, and anything the check could not see.

## Environment

A check is only as real as the place it runs. Code for Workers runs in an emulator such as Miniflare or workerd, code that stores data runs against a database, and a service may need its whole backend stack up.

- Look before you build: the project's `AGENTS.md`, `CONTRIBUTING.md`, and README, tests that already start what you need (search for the emulator or container they use), and any compose file or sibling repo that prepares the stack.
- Reuse an environment that is already up, after you confirm it is healthy. When you finish, stop what you started and leave running what you found running.
- Keep shared state as you found it: the loaded data set, the selected account, the current cluster. Change it only when the task needs it, and say what you changed.
- Prefer a local emulator or container to a live service. Live services, production data, and shared servers need your human's go.
- When no environment exists, building it is your first unit of work.
- When a check fails, first find out whether the environment or the code failed. A stopped container or an expired login is setup to fix, not a change to undo.
- When the setup was hard to find, say in your report where the project should write it down, so the next agent finds it.

## Real wins only

A real win makes the code better on inputs the check has never seen: a better algorithm, a real fix, less real work. If the only way up is to special-case the check's inputs, hard-code answers, shrink the test data, loosen or skip a test, or hide an error, the check is wrong. Say so and fix the check (step 4) instead of chasing the score.

When a check is easy to game without noticing, like a timing on a fixed input, keep a few **holdout** cases you never look at while working. Run them at the end. If the check improved and the holdout didn't, you fit the check, not the goal.

Ask your human only when a check fails and you can't explain why, or the next step needs something only they can give.
