---
name: vitehub-projects
disable-model-invocation: true
description: Routes ViteHub projects and consumers to their local project roots and GitHub coordinates when available. Use when the user mentions ViteHub itself, a ViteHub template or app, Formula 100, or a Quiver Agent, Airtable, Babysitter, Chat, Portal, Review, or Wiki project.
---

# ViteHub Projects

Resolve the project before inspecting or changing its files. This skill owns project selection only; the original request remains the authority boundary for work inside that project.

## Projects

| Project root | GitHub repository |
| --- | --- |
| `~/onmax/bitacora-agent` | `gh:onmax/bitacora-agent` |
| `~/onmax/formula-100` | `gh:onmax/formula-100-next` |
| `~/quiver/agents` | `gh:quiverdk/agents` |
| `~/quiver/airtable` | `gh:onmax/quiver-airtable` |
| `~/quiver/babysitter` | `gh:onmax/quiver-babysitter` |
| `~/quiver/chat` | `gh:quiverdk/agents` |
| `~/quiver/portal` | `gh:quiverdk/portal` |
| `~/quiver/review` | `gh:quiverdk/janos` |
| `~/quiver/wiki` | `gh:cloudflare/cloudflare-os-starter` |
| `~/quiver/wiki-2` | Local only |
| `~/vitehub/babysitter` | `gh:vite-hub/babysitter` |
| `~/vitehub/brief` | `gh:vite-hub/brief` |
| `~/vitehub/calories` | `gh:onmax/calories` |
| `~/vitehub/chat` | `gh:vite-hub/chat-template` |
| `~/vitehub/drop` | `gh:vite-hub/drop` |
| `~/vitehub/harness-demo` | `gh:vite-hub/harness-demo` |
| `~/vitehub/nuxt-agent` | `gh:vite-hub/nuxt-agent` |
| `~/vitehub/vitehub` | `gh:vite-hub/vitehub` |

## Resolution

1. Prefer an exact project name or GitHub coordinate from the user. Use the current project, named files, PR context, or other explicit context to disambiguate `babysitter`; ask whether they mean Quiver or ViteHub only when that evidence does not resolve it.
2. Expand `~` to an absolute path and verify that the selected directory exists. When it is missing, report the expected path and wait for correction.
3. Use the resolved root as the working directory, read its local instructions, and continue the original request. Resolution is complete only when one existing project root is selected.
