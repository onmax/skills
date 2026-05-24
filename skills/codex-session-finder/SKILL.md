---
name: codex-session-finder
description: Finds local Codex sessions by thread id, title, repo path, rollout path, or session topic and summarizes the metadata needed for review. Use when the user wants to locate a past Codex thread, inspect what happened in a session, or gather evidence to debug and improve agent skills.
---

# Codex Session Finder

Find the relevant local Codex session and return enough evidence for a human or another skill to review what happened.

## How Codex Sessions Work

Codex keeps local session state under the user's Codex home directory.

- `state_5.sqlite` stores thread metadata, including id, title, workspace path, timestamps, archive state, branch, commit, `tokens_used`, and rollout path.
- `session_index.jsonl` is a lightweight session index. It is useful for lookup, but SQLite is the stronger source of truth when both exist.
- `sessions/` contains current rollout files.
- `archived_sessions/` contains archived rollout files.
- Rollout files are JSONL event streams. Use them only when metadata is not enough.

## Inputs

Accept any of these:

- thread id
- session title
- repository or workspace path
- rollout file path
- natural-language session topic

If the input is vague, search metadata first and return likely candidates rather than guessing silently.

## Active Worktree Lookup

Use this mode when another skill needs to avoid active Codex worktrees, coordinate multiple worktrees, or understand which local branches are currently being edited.

Query active, non-archived sessions first:

```sh
sqlite3 -header -column ~/.codex/state_5.sqlite \
  "select id, title, cwd, datetime(created_at,'unixepoch') as created_at,
          datetime(updated_at,'unixepoch') as updated_at,
          git_branch, git_sha, tokens_used, rollout_path
   from threads
   where archived = 0
   order by updated_at desc;"
```

For a specific repo or worktree family, filter by `cwd`:

```sh
sqlite3 -header -column ~/.codex/state_5.sqlite \
  "select id, title, cwd, datetime(updated_at,'unixepoch') as updated_at,
          git_branch, git_sha, rollout_path
   from threads
   where archived = 0
     and cwd like '%/vitehub%'
   order by updated_at desc;"
```

Before selecting optional columns in a newer or older Codex install, inspect the schema:

```sh
sqlite3 ~/.codex/state_5.sqlite '.schema threads'
```

Use `tokens_used` for token counts in current schemas; do not select `token_count` unless the schema actually contains it.

Report active worktrees as off-limits for mutating follow-up tasks unless the user explicitly says to use that session's worktree.

## Search Order

1. Query `state_5.sqlite`.
   - Prefer the `threads` table.
   - Match exact ids first.
   - Match titles, workspace paths, rollout paths, and prompt previews next.
   - Rank active sessions before archived sessions, then sort by most recently updated.

2. Check `session_index.jsonl` when SQLite does not resolve the request.
   - Use it to connect ids, thread names, and updated timestamps.
   - Treat it as supporting evidence, not the final source of truth.

3. Search rollout files only when needed.
   - Search `sessions/` and `archived_sessions/`.
   - Use distinctive text from the user's request.
   - Prefer narrow searches over broad scans.

## Output

Return a compact report:

```md
Best match:
- id:
- title:
- cwd:
- created:
- updated:
- archived:
- branch:
- git sha:
- tokens used:
- rollout path:

Why this match:
- <short evidence>

Evidence slice:
- <small relevant excerpt or summary>

Other candidates:
- <include only when ambiguity matters>
```

For active worktree lookups, use:

```md
Active sessions:
1. <id> - <title>
   - cwd:
   - branch:
   - updated:
   - rollout path:

Likely safe/inactive related worktrees:
- ... <!-- only if discovered from metadata and clearly archived/inactive -->

Use guidance:
- Treat active session worktrees as read-only/off-limits unless the user explicitly opts in.
```

## Rules

- Stay read-only.
- Do not modify Codex state, rollout files, repositories, or skill files.
- Do not expose unnecessary private session content.
- Do not deeply analyze the session unless the user asks for that separately.
- If the user wants to improve skills, retrieve the session evidence first and keep the output suitable for a follow-up review.
- Prefer precise local metadata over broad text search.
- If multiple matches are plausible, show the top candidates.
