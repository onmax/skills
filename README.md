# Skills

Personal agent skills you can install with the Skills CLI.

## Install

See what is available:

```sh
npx skills add onmax/skills --list
```

Install all skills:

```sh
npx skills add onmax/skills --skill '*' --global --yes
```

Install one skill:

```sh
npx skills add onmax/skills --skill grill-with-docs --global --yes
```

Install for a specific agent:

```sh
npx skills add onmax/skills --skill grill-with-docs --agent codex --global --yes
```

## Included skills

- `ecosystem-research`
- `fast-forward`
- `grill-with-docs`
- `validate-direction`

## References

These skills build on patterns and ideas from:

- [fpgarciamtnz/World-of-Sofia](https://github.com/fpgarciamtnz/World-of-Sofia)
- [mattpocock/skills](https://github.com/mattpocock/skills)
