---
name: codex-session-finder
description: Finds local Codex sessions by thread id, title, repo path, rollout path, or session topic and returns thread-level locator metadata. Use when the user wants to locate a past Codex thread or give another agent the session coordinates needed for its own review.
---

# Codex Session Finder

Find the relevant local Codex session and return the session coordinates. This skill locates the thread; it does not summarize, judge, or extract the important parts of the conversation unless the user explicitly asks for inspection.

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

## Optional Turn Export

Use this only when the user asks to inspect, review, debug, or hand off the session content. Do not export turns for a plain lookup.

Write a temporary turn-by-turn export under `/tmp` or the system temp directory, never inside the target repository. Prefer Markdown or JSONL with one entry per conversation turn, preserving role, timestamp when available, and a short content preview or full content depending on the user's request.

Return the temp export path with the session locator:

```md
Export:
- turns path: /tmp/<file>
```

Keep the chat content out of the assistant response unless the user explicitly asks for excerpts. A temp export lets the next agent search, summarize, or review the thread independently without making the locator output noisy.

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

3. Search rollout files only when needed to identify the session.
   - Search `sessions/` and `archived_sessions/`.
   - Use distinctive text from the user's request.
   - Prefer narrow searches over broad scans.
   - Stop after finding the locator metadata unless the user asked to inspect session content.

## Output

Return a compact metadata report. The result is a locator, not a narrative or review.

For one clear match, especially an exact thread id or rollout path match, use:

```md
Found session:
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
```

Do not include "Why this match", confidence language, or an evidence slice for exact or otherwise unambiguous matches. The metadata is the output.

Include fields that help another agent route its own follow-up work: id, title, cwd, timestamps, archive state, branch, commit, token count, and rollout path. Do not decide which conversation turns are "important"; a follow-up agent should inspect the rollout file on its own when it needs content.

Include a short "Match basis" only when the input was vague, multiple candidates are plausible, or the lookup used fallback sources:

```md
Match basis:
- <short factual reason, such as title/path/token match>

Other candidates:
- <include only when ambiguity matters>
```

Include an "Evidence slice" only when the user asks to inspect what happened in the session or metadata alone cannot identify the right session. Keep excerpts minimal and summarize private content when possible.

If a temp turn export was requested, include only the export path in the main response. Do not duplicate the exported content in the response.

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
- Do not modify Codex state, rollout files, repositories, or skill files. Temporary exports under `/tmp` are allowed only when requested.
- Do not expose unnecessary private session content.
- Do not deeply analyze the session unless the user asks for that separately.
- Do not infer or report the important parts of the thread by default; return the locator so the next agent can search the rollout for its own purpose.
- If the user wants to improve skills, first return the session locator. Retrieve session evidence only when the requested review needs it.
- Prefer precise local metadata over broad text search.
- If multiple matches are plausible, show the top candidates.
