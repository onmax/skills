# Skill Hygiene

Use this as a read-only checklist for daily/weekly retrospectives and explicit skill-cleanup requests.

The goal is to learn from skill usage without creating churn. A skill that is rarely used can still be valuable if it encodes project policy, live operations, private vocabulary, or a hard-won safety rule.

Scope the pass over all visible/enabled skills in the session: system roots, personal roots, repo-local roots, plugin roots, and cached curated roots. Do not limit the scan to the current repository just because the automation runs from the skills repo.

## Evidence To Collect

- `Skill Budget`: approximate model-visible prompt pressure from all skill list entries. Use the visible line shape `- name: description (file: path)` as the budget unit.
- `Description Candidates`: descriptions that are long, vague, duplicate another skill, or bury trigger words.
- `Duplicates`: same skill name, very similar description, or near-copy body across enabled roots, repo-local roots, personal roots, and plugin/cache roots.
- `Unused Candidates`: no recent `$skill` mention, `SKILL.md` read, or explicit skill-use trace in recent Codex sessions.
- `Root Summary`: every visible root plus where each candidate came from, including whether the root is repo-local, personal, system, plugin, cache, or disabled.

## Cleanup Rules

- Suggest first. Do not delete, rewrite, disable, move, or commit skill changes unless the user explicitly asks to apply cleanup.
- Verify the kept copy exists and is loaded before recommending deletion or disabling.
- Prefer keeping direct Codex/system skills and repo-local maintainer skills when they encode policy or live operations.
- Prefer removing or disabling duplicates only when the body is a near-copy and the kept skill covers the same trigger.
- Preserve trigger nouns in descriptions: product, tool, action, object.
- Rewrite descriptions for routing clarity, not prose polish.
- Do not treat absence of recent usage as enough evidence to delete safety, security, deployment, or incident-response skills.

## Output Shape

```md
Skill hygiene:
- Budget pressure: none | low | medium | high, with reason
- Description candidates: ...
- Duplicates: ...
- Unused candidates: ...
- Root summary: ...

Apply only if asked:
- Delete/disable candidates: ...
- Description rewrites: ...
```
