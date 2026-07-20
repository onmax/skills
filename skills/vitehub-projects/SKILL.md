---
name: vitehub-projects
description: Routes ViteHub projects to their local repository roots and GitHub coordinates. Use when the user mentions a ViteHub project, Quiver Agents, Quiver Babysitter, ViteHub Babysitter, Nuxt Agent, Bitacora Audio, ViteHub Summary, or ViteHub Drop.
---

# ViteHub Projects

Resolve the repository before inspecting or changing project files. This skill owns repository selection only; the original request remains the authority boundary for work inside that repository.

## Projects

| Repository root | GitHub repository |
| --- | --- |
| `~/quiver/agents` | `gh:quiverdk/agents` |
| `~/quiver/babysitter` | `gh:onmax/quiver-babysitter` |
| `~/vitehub/babysitter` | `gh:vite-hub/babysitter` |
| `~/vitehub/nuxt-agent` | `gh:vite-hub/nuxt-agent` |
| `~/onmax/bitacora-agent` | `gh:onmax/bitacora-agent` |
| `~/vitehub/summary` | `gh:vite-hub/brief` |
| `~/vitehub/drop` | `gh:vite-hub/drop` |

## Resolution

1. Prefer an exact project name or GitHub coordinate from the user. Use the current repository, named files, PR context, or other explicit context to disambiguate `babysitter`; ask whether they mean Quiver or ViteHub only when that evidence does not resolve it.
2. Expand `~` to an absolute path and verify that the selected directory exists. When it is missing, report the expected path and wait for correction.
3. Use the resolved root as the working directory, read its local instructions, and continue the original request. Resolution is complete only when one existing repository root is selected.
