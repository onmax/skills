#!/usr/bin/env bash
set -euo pipefail

for bin in git gh zed; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$bin" >&2
    exit 127
  fi
done

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  printf 'Not inside a Git worktree.\n' >&2
  exit 1
fi

cd "$repo_root"

pr_info="$(gh pr view --json number,baseRefName,url --jq '[.number, .baseRefName, .url] | @tsv' 2>/dev/null || true)"
if [[ -z "$pr_info" ]]; then
  printf 'No GitHub pull request found for the current branch.\n' >&2
  exit 1
fi

IFS=$'\t' read -r pr_number base_ref pr_url <<< "$pr_info"
if [[ -z "$base_ref" || "$base_ref" == "null" ]]; then
  printf 'Could not resolve the pull request base branch.\n' >&2
  exit 1
fi

base_commit=""
for remote in origin upstream $(git remote | grep -vE '^(origin|upstream)$' || true); do
  if git remote get-url "$remote" >/dev/null 2>&1 && git fetch --quiet "$remote" "$base_ref"; then
    base_commit="$(git rev-parse FETCH_HEAD)"
    break
  fi
done

if [[ -z "$base_commit" ]]; then
  printf 'Could not fetch PR base branch %s from any Git remote.\n' "$base_ref" >&2
  exit 1
fi

merge_base="$(git merge-base HEAD "$base_commit")"
repo_name="$(basename "$repo_root" | tr -c 'A-Za-z0-9._-' '-')"
diff_root="$(mktemp -d "${TMPDIR:-/tmp}/zed-pr-review-${repo_name}-pr-${pr_number}-XXXXXX")"
review_dir="$diff_root/worktree"
patch_file="$diff_root/pr.diff"
state_dir="${HOME}/.agents/state/diff"
state_file="${state_dir}/${repo_name}-pr-${pr_number}.env"

git diff --binary "$merge_base" -- > "$patch_file"
if [[ ! -s "$patch_file" ]]; then
  printf 'No local diff found against PR #%s base branch %s.\n' "$pr_number" "$base_ref" >&2
  exit 1
fi

git clone --quiet --shared --no-checkout "$repo_root" "$review_dir"
git -C "$review_dir" checkout --quiet --detach "$merge_base"
git -C "$review_dir" apply "$patch_file"

mkdir -p "$state_dir"
cat > "$review_dir/.ai-review-context" <<EOF
PR_NUMBER=$pr_number
PR_URL=$pr_url
SOURCE_WORKTREE=$repo_root
REVIEW_WORKTREE=$review_dir
BASE_BRANCH=$base_ref
MERGE_BASE=$merge_base
EOF
cat > "$state_file" <<EOF
PR_NUMBER=$pr_number
PR_URL=$pr_url
SOURCE_WORKTREE=$repo_root
REVIEW_WORKTREE=$review_dir
BASE_BRANCH=$base_ref
MERGE_BASE=$merge_base
EOF

zed "$review_dir"
printf 'Opened PR #%s diff in Zed: %s\n' "$pr_number" "$pr_url"
printf 'Temporary review worktree: %s\n' "$review_dir"
printf 'Review context: %s\n' "$state_file"
printf 'Open Zed Git panel if it is hidden: cmd-shift-g\n'
