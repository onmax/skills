---
name: vitehub-projects
description: Routes ViteHub project names and aliases to their local repository roots. Use when the user mentions a ViteHub project, Quiver Agents, Quiver Babysitter, ViteHub Babysitter, Nuxt Agent, Bitacora Audio, or ViteHub Summary.
---

# ViteHub Projects

Resolve the repository before inspecting or changing project files. This skill owns repository selection only; the original request remains the authority boundary for work inside that repository.

## Aliases

| Alias | Repository root |
| --- | --- |
| `agents`, `quiver-agents` | `~/quiver/agents` |
| `quiver-babysitter` | `~/quiver/babysitter` |
| `vitehub-babysitter` | `~/vitehub/babysitter` |
| `nuxt-agent` | `~/vitehub/nuxt-agent` |
| `bitacora-audio` | `~/onmax/bitacora-agent` |
| `summary`, `vitehub-summary` | `~/vitehub/summary` |

Accept spaces in place of hyphens when the project identity remains unambiguous.

## Resolution

1. Prefer a qualified alias from the user. Use the current repository, named files, PR context, or other explicit context to disambiguate `babysitter`; ask whether they mean Quiver or ViteHub only when that evidence does not resolve it.
2. Expand `~` to an absolute path and verify that the selected directory exists. When it is missing, report the expected path and wait for correction.
3. Use the resolved root as the working directory, read its local instructions, and continue the original request. Resolution is complete only when one existing repository root is selected.
