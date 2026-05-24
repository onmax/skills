# Codex Evidence

Use these commands as recipes, not as mandatory scripts. Prefer precise queries before broad rollout scans.

## Locate Codex State

Common Codex home:

```sh
ls -la ~/.codex
```

If `$CODEX_HOME` is set, use it. If not, default to `~/.codex`; do not query `/automations` or other root-relative paths by accident.

Useful files and directories:

```sh
ls -la ~/.codex/state_5.sqlite ~/.codex/session_index.jsonl ~/.codex/sessions ~/.codex/archived_sessions 2>/dev/null
```

## Inspect SQLite Shape

```sh
sqlite3 ~/.codex/state_5.sqlite '.tables'
sqlite3 ~/.codex/state_5.sqlite '.schema threads'
```

## Find Recent Sessions

Start with the last 24 hours unless the user gives another scope. Adapt timestamp columns to the current schema.

```sh
sqlite3 -header -column ~/.codex/state_5.sqlite \
  "select id, substr(replace(title, char(10), ' '), 1, 120) as title,
          cwd, datetime(created_at,'unixepoch') as created_at,
          datetime(updated_at,'unixepoch') as updated_at,
          archived, coalesce(git_branch,'') as branch,
          substr(coalesce(git_sha,''),1,12) as git_sha, rollout_path
   from threads
   where updated_at >= strftime('%s','now','-1 day')
   order by updated_at desc;"
```

If timestamps are stored as milliseconds, inspect a few rows first:

```sh
sqlite3 -header -column ~/.codex/state_5.sqlite \
  "select id, title, cwd, created_at, updated_at, rollout_path
   from threads
   order by updated_at desc
   limit 20;"
```

## Search by Topic, Repo, or Thread

```sh
sqlite3 -header -column ~/.codex/state_5.sqlite \
  "select id, title, cwd, updated_at, rollout_path
   from threads
   where id like '%SEARCH%'
      or title like '%SEARCH%'
      or cwd like '%SEARCH%'
      or rollout_path like '%SEARCH%'
   order by updated_at desc
   limit 20;"
```

## Use Session Index as Supporting Evidence

```sh
rg -n "SEARCH" ~/.codex/session_index.jsonl
```

The SQLite database is the stronger source of truth when both exist.

## Read Rollout Files Safely

Prefer structured extraction with `jq` over dumping full JSONL into chat.

List event types:

```sh
jq -r '.type // .role // empty' /path/to/rollout.jsonl | sort | uniq -c
```

Extract user messages:

```sh
jq -r '
  select(.type == "message" or .item.type == "message") |
  select((.role // .item.role) == "user") |
  (.content // .item.content // "")
' /path/to/rollout.jsonl
```

Search for skill mentions and user corrections:

```sh
rg -n "[$][a-z0-9-]+|wrong|no|wait|actually|push|comment|PR|GitHub|failed|stuck|why" /path/to/rollout.jsonl
```

If `jq` is missing or the rollout stores messages under `response_item.payload`, use Python:

```sh
python3 - <<'PY' /path/to/rollout.jsonl
import json, re, sys
for line in open(sys.argv[1]):
    obj = json.loads(line)
    payload = obj.get("payload") if obj.get("type") == "response_item" else obj
    if not isinstance(payload, dict) or payload.get("type") != "message":
        continue
    if payload.get("role") != "user":
        continue
    text = "\n".join(part.get("text", "") for part in payload.get("content", []) if isinstance(part, dict))
    if text.startswith("# AGENTS.md instructions") or "<environment_context>" in text:
        continue
    print(" ".join(text.split())[:1000])
PY
```

## Remote Codex Sessions

When remote/VPS Codex sessions are in scope, use `vps-connection` first. Query remote Codex homes read-only, usually `/home/maxi/.codex` and `/home/maxi/.codex-pipoyu`, and prefer metadata before rollout reads. If the remote lacks `sqlite3`, use Python's standard `sqlite3` module over SSH.

## Evidence Priorities

- User prompts, corrections, redirects, approvals, and frustration signals.
- Explicit skill mentions and missed obvious skill routes.
- Repo paths, branches, PR URLs, commit SHAs, and check links.
- Assistant/tool actions only when needed to explain the pattern.

Paraphrase by default. Quote only tiny excerpts when exact wording proves a trigger or instruction issue.
