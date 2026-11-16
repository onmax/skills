# Skills

Agent skills I use every day with Claude Code and Codex. Each one is a folder with a `SKILL.md`.

| Skill | Use it when |
| --- | --- |
| [`paper-cuts`](skills/paper-cuts/SKILL.md) | Use before ending a turn in which you hit a paper cut: a bug or gap in a library or tool we use, a surprise on the machine, or something you were blocked from doing. |
| [`boil-the-ocean`](skills/boil-the-ocean/SKILL.md) | Use for any big task, one that spans many files, steps, or sessions or would take a person days or more, and whenever you are tempted to cut scope or leave part of a task for later. |
| [`research`](skills/research/SKILL.md) | Use when the user asks how others or the industry handle something, what the standard is, or wants evidence before a decision. |
| [`check-your-work`](skills/check-your-work/SKILL.md) | Use before fixing a bug, adding a feature, refactoring, porting, or speeding up code, or when asked to verify a change, prove it works, or keep going until it passes. |

## Install

```sh
npx skills add onmax/skills
```

Or copy a folder into `~/.claude/skills/` (Claude Code) or `~/.agents/skills/` (Codex).

## How this repo works

I edit my skills in a private repository, where most of them are tied to my machines and accounts. The ones listed here are published from it automatically, with the private parts taken out. Pull requests here would be overwritten by the next sync, so open an issue instead.

## Credits

Skills by other people that I use alongside these:

- [`council`](https://github.com/t3dotgg/tstack/tree/main/skills/council) and [`sol-loop`](https://github.com/t3dotgg/tstack/tree/main/skills/sol-loop) from [t3dotgg/tstack](https://github.com/t3dotgg/tstack)
- [`ag-dev`](https://github.com/ag-grid/skills/tree/main/skills/ag-dev) and [`ag-update`](https://github.com/ag-grid/skills/tree/main/skills/ag-update) from [ag-grid/skills](https://github.com/ag-grid/skills)
- [`ui-skills`](https://github.com/ibelick/ui-skills) by ibelick

## License

MIT
