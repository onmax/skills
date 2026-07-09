#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<'USAGE'
Usage: summonize-pr-comments.sh [gh:owner/repo ...]

Prints the fixed prompt for a PR Comment Sentinel heartbeat.
Defaults to gh:vite-hub/vitehub.
USAGE
  exit 0
fi

repos=("$@")
if [ "${#repos[@]}" -eq 0 ]; then
  repos=("gh:vite-hub/vitehub")
fi

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
workspace="${PR_COMMENT_SENTINEL_WORKSPACE:-/home/workspace}"
comment_account="${PR_COMMENT_SENTINEL_COMMENT_ACCOUNT:-onmax}"

repo_list=""
no_merge_list=""
for repo in "${repos[@]}"; do
  repo_list+="- ${repo}"$'\n'
  if [ "${repo}" = "gh:quiverdk/portal" ] || [ "${repo}" = "quiverdk/portal" ]; then
    no_merge_list+="- ${repo}"$'\n'
  fi
done
if [ -z "${no_merge_list}" ]; then
  no_merge_list="- none"$'\n'
fi

cat <<PROMPT
Use \$pr-comment-sentinel from ${skill_dir}.

Watch these repositories:
${repo_list}
Repositories where automatic merge is disabled:
${no_merge_list}
Workspace root: ${workspace}
Clarification comments disabled unless Maxi explicitly grants comment permission for this run.
Review nudges disabled unless Maxi explicitly grants comment permission for this run.

Run one passive PR-comment heartbeat:
1. Load workflow. This root session is a coordinator first: reconcile, spawn observable workers when possible, steer, verify short read-only state, report, and exit. Resolve the current GitHub user with gh. Only handle open PRs authored by that user. Run one bounded single pass: do not use gh pr checks --watch, sleep/poll loops, or collab: Wait for spawned fix workers or pending checks. If a PR is not ready now, report the blocker and exit so the timer can re-list the queue on the next run.
2. For each watched repo in the listed order, start with metadata-only PR listing: number, title, author, head SHA, head branch, draft state, merge state, updated time, and URL. Never call gh pr list with comments, reviews, latestReviews, or statusCheckRollup. Use gh pr view or GraphQL only for individual candidate PRs. Use gh api graphql for unresolved review threads and PR reactions; do not call gh pr view --json reviewThreads. A PR-level THUMBS_UP reaction from chatgpt-codex-connector[bot] created after the latest commit counts as a fresh Codex signal for the current head only when there is no newer @codex command waiting on a Codex bot result.
3. Build a lane ledger with one lane per PR: PR number, title, head SHA, owner, lane type, state, and blocker. Treat clean merge-ready PRs as actionable even when there is no new Codex thread; evaluate and merge/skips these candidates in repo order before fetching comments/reviews for blocked, dirty, draft, stale, or non-authored PRs. Understand the intent of each new Codex signal. Fix only actionable bugs, regressions, missing checks, unclear behavior, or maintainability issues worth carrying. Skip stale, false-premise, already-handled, or taste-bad comments.
4. Before handing off, pushing to, or merging a watched PR, confirm its title follows Conventional Commits: <type>(<scope>)?: <subject>, for example fix(agent): honor webhook runtimes. If the title does not match and the correct title is clear from the PR, rename it with gh pr edit --title. If the correct title is not clear, do not merge; report the title blocker.
5. Start all independent ready or actionable lanes before waiting on any lane. A lane is not considered spawned unless it has either a durable child-thread id that can be polled or an observable OS worker with a pid file and log path. Do not report abstract owners, local subagents, or thread ids as spawned unless you can poll them. For each actionable PR/comment group, create or reuse a worktree under ${workspace}/pr-comment-sentinel/<owner-repo>/pr-<number>-<head>. If a durable child-thread tool is callable, use it and record the pollable thread id. Otherwise launch a detached Codex worker process from that worktree:
   - write a worker prompt at <worktree>/.pr-comment-sentinel-worker.prompt.md that tells the worker to load workflow and pr-refiner, own only that PR/head, make the smallest fix, preserve or repair the Conventional Commits PR title, run focused checks, push to the PR branch, resolve addressed threads silently, write a final status line, and leave the worktree/log/pid for the next heartbeat to inspect. Worker commits must use a single-line subject only: no commit body and no Co-authored-by trailers. The worker must not stop after printing or inspecting a diff; after any local edit it must either run the focused check, commit/push, and write status=pushed, or write status=blocked with the exact blocker.
   - launch it with: setsid /bin/bash -lc 'exec /usr/local/bin/codex exec --dangerously-bypass-approvals-and-sandbox -C "<worktree>" - < "<worktree>/.pr-comment-sentinel-worker.prompt.md" > "<worktree>/.pr-comment-sentinel-worker.log" 2>&1' </dev/null & echo \$! > <worktree>/.pr-comment-sentinel-worker.pid
   - verify kill -0 \$(cat <worktree>/.pr-comment-sentinel-worker.pid) succeeds before recording the lane as running
   - use a per-PR lock or existing live pid to avoid launching a duplicate worker for the same PR/head
   If no durable child-thread tool exists and a detached OS worker cannot be launched and verified, handle at most one actionable PR lane inline during this heartbeat, then report that parallel workers were unavailable. Do not wait for verified workers inside this heartbeat; record owner/running state, pid/log/thread evidence, and let the next heartbeat inspect the resulting PR head.
6. Do not post clarification comments or any other PR/issue comments unless Maxi explicitly grants comment permission for this run.
7. Do not post "@codex review" or any other PR/issue comment unless Maxi explicitly grants comment permission for this run.
8. If Codex replies that code-review usage limits were reached, treat the current head as review-unavailable. Do not post another "@codex review" for that head, do not try to switch Codex or ChatGPT accounts, and do not copy, move, or inspect auth material to bypass the limit.
9. Before working the fix queue, evaluate merge-ready PRs first. Track each PR independently; do not let pending checks or blockers in one repo delay an unrelated PR whose own gates are satisfied. Before fallback review, query PR-level reactions and latest commit time; if chatgpt-codex-connector[bot] added THUMBS_UP after the latest commit and ${skill_dir}/scripts/codex-command-blocker.sh <owner/repo> <pr> <current-head> exits 0, treat that as the fresh Codex signal and skip fallback review for that PR. If the blocker script reports a newer @codex command, do not start fallback review and do not merge; record that output as the blocker because the external Codex lane is newer than local evidence. When normal merge conditions are otherwise satisfied but the only missing condition is a fresh GitHub Codex review or reaction signal, start a separate bounded internal fallback review owner for that PR without posting to the PR. The fallback review must be carried out by a separate observable read-only review owner; do not self-review locally in the heartbeat and do not serialize fallback reviews across PRs. A review owner is not considered spawned unless it has either a durable child-thread id that can be polled or an observable OS review worker with pid, log, prompt, and status paths. If durable child-thread tools are unavailable, create or reuse the PR worktree and write <worktree>/.pr-comment-sentinel-review.prompt.md telling the reviewer to load workflow, inspect only that PR/head, review the diff against base for correctness, behavior regressions, security issues, missing tests, and mismatch with PR intent, make no edits, post no comments, push nothing, resolve nothing, merge nothing, and write exactly one status line to <worktree>/.pr-comment-sentinel-review.status: verdict=<no-major-issues|needs-fix|inconclusive> head=<sha> reason="<short reason>". Launch it with: setsid /bin/bash -lc 'exec /usr/local/bin/codex exec --dangerously-bypass-approvals-and-sandbox -C "<worktree>" - < "<worktree>/.pr-comment-sentinel-review.prompt.md" > "<worktree>/.pr-comment-sentinel-review.log" 2>&1' </dev/null & echo \$! > <worktree>/.pr-comment-sentinel-review.pid. Verify kill -0 \$(cat <worktree>/.pr-comment-sentinel-review.pid) succeeds before recording it as running. Do not wait for verified OS review workers inside the heartbeat; a later heartbeat must inspect the status marker for the exact head. If a review owner cannot be created, treat the fallback verdict as inconclusive.
10. Repository-specific merge policy: automatic merge is allowed for gh:vite-hub/vitehub, but disabled for gh:quiverdk/portal. For any no-merge repository, including gh:quiverdk/portal, never call gh pr merge, never enable auto-merge, and never delete the branch. Marking an otherwise-ready authored draft PR ready for review with gh pr ready is allowed in no-merge repositories. If a no-merge PR satisfies every normal merge gate, mark it ready for review when applicable, report it as ready-for-human-review, and stop; do not merge it. For merge-allowed repositories only: if a PR is authored by the current GitHub user, has a Conventional Commits title, is a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, ${skill_dir}/scripts/codex-command-blocker.sh <owner/repo> <pr> <current-head> exits 0, and either the latest Codex signal is a thumbs-up/no-major-issues signal for the current head, a PR-level Codex bot thumbs-up reaction was created after the latest commit, or an observable internal fallback review owner returned no-major-issues for the current head after comments are disabled or Codex review is unavailable, mark it ready for review with gh pr ready. Then immediately re-read the PR head, draft state, checks, review threads, and ${skill_dir}/scripts/codex-command-blocker.sh <owner/repo> <pr> <current-head> before deciding merge readiness. Merge without waiting only when the repository is merge-allowed, the blocker script exits 0, the PR is authored by the current GitHub user, has a Conventional Commits title, is not a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and either the latest Codex signal is a thumbs-up/no-major-issues signal for the current head, a PR-level Codex bot thumbs-up reaction was created after the latest commit, or an observable internal fallback review owner returned no-major-issues for the current head after comments are disabled or Codex review is unavailable. Use the recent repository strategy: squash merge with subject exactly <PR title> (#<PR number>) and an empty body; pass the empty body explicitly so GitHub does not add the commit list or Co-authored-by trailers. Delete the PR branch when GitHub allows it for same-repo branches. Do not merge after needs-fix or inconclusive fallback verdicts, when no review owner was available, when the blocker script reports a newer @codex command, when new commits landed after the fallback review, or when the repository is no-merge. If a worker pushed a fix, do not wait for checks; revisit it in a later heartbeat after checks are already green, then run a fresh fallback review for that new head before considering merge.
11. On each heartbeat, first inspect any existing worker pid/log/thread for the same PR/head before launching a new worker. If the worker is still alive, report the last useful log lines and do not duplicate it. If the worker exited, inspect its log, local worktree diff, current PR head, checks, and unresolved threads before deciding whether to continue, relaunch, merge, or mark blocked. If an exited worker has local diffs and no .pr-comment-sentinel-worker.status, treat it as an orphaned in-progress lane: launch one continuation worker in the same worktree with the same PR/head and explicit instructions to continue from the existing diff, run the focused check, commit, push, resolve verified addressed threads, and write status. Do not discard or overwrite the local diff unless it is clearly wrong and you record why.
12. Report the lane ledger: PR number, title, head SHA, owner, lane type, action taken, pollable thread id or worker pid/log, skipped comments with reason, pushed commit, resolved threads, review nudges, fallback verdict, merge result, worktree cleanup, and blockers.
PROMPT
