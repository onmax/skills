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
for repo in "${repos[@]}"; do
  repo_list+="- ${repo}"$'\n'
done

cat <<PROMPT
Use \$pr-comment-sentinel from ${skill_dir}.

Watch these repositories:
${repo_list}
Workspace root: ${workspace}
Comment account for rare clarification comments: ${comment_account}
Allowed review nudge when needed: @codex review

Run one passive PR-comment heartbeat:
1. Resolve the current GitHub user with gh. Only handle open PRs authored by that user.
2. For each watched repo, list open PRs, titles, current head SHAs, unresolved review threads, reviews, checks, comments from Codex, and merge readiness.
3. Understand the intent of each new Codex signal. Fix only actionable bugs, regressions, missing checks, unclear behavior, or maintainability issues worth carrying. Skip stale, false-premise, already-handled, or taste-bad comments.
4. Before handing off, pushing to, or merging a watched PR, confirm its title follows Conventional Commits: <type>(<scope>)?: <subject>, for example fix(agent): honor webhook runtimes. If the title does not match and the correct title is clear from the PR, rename it with gh pr edit --title. If the correct title is not clear, do not merge; report the title blocker.
5. For each actionable PR/comment group, summon or run one agent with T3 Code or Codex built-in worktree support under ${workspace}/pr-comment-sentinel/<owner-repo>/pr-<number>-<head>. Tell it to load workflow and pr-refiner, make the smallest fix, preserve or repair the Conventional Commits PR title, run focused checks, push to the PR branch, resolve addressed threads silently, and remove the clean worktree.
6. Do not comment in the normal case. Only post a ${comment_account} clarification comment when the task is unnecessary or genuinely ambiguous, then report the exact body and URL for review.
7. If a watched PR/head needs a fresh Codex review signal and there is no current one, you may post exactly "@codex review" once for that head.
8. Merge without waiting when the PR is authored by the current GitHub user, has a Conventional Commits title, is not a draft, has a clean merge state, all required checks succeeded, no unresolved current review threads remain, and the latest Codex signal is a thumbs-up or no-major-issues comment for the current head. Use the recent repository strategy: squash merge. Delete the PR branch when GitHub allows it for same-repo branches.
9. Report PR number, title, head SHA, action taken, skipped comments with reason, pushed commit, resolved threads, review nudges, merge result, worktree cleanup, and blockers.
PROMPT
