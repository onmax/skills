---
name: writing-web-documentation
description: Write, rewrite, review, and organize developer-facing documentation for web software projects. Use when creating or improving README files, docs homepages, quickstarts, tutorials, how-to guides, API/reference pages, conceptual explanations, migration guides, or troubleshooting content for frontend, backend, full-stack, SDK, API, or framework-based web products. This skill applies strong information architecture, task-first page structure, clear voice, runnable examples, version and prerequisite hygiene, accessibility rules, and docs-as-code maintenance habits. Do not use it for marketing copy, legal text, or non-technical customer-support articles.
compatibility: Instruction-only skill with Markdown templates and research notes. Best for docs-as-code repositories, READMEs, and documentation sites.
metadata:
  version: "1.0.0"
  author: "OpenAI"
---

# Writing web documentation

Use this skill when the user wants excellent technical documentation for a web project, not merely "some text around the code." The job is to produce documentation that is easy to enter, easy to scan, easy to trust, and easy to maintain.

Good documentation is not a dump of product facts. It is a guided path through the product for a reader with a specific goal.

## What this skill optimizes for

1. **Fast first success**  
   A new reader should reach a working result quickly.

2. **Clear routing by intent**  
   A beginner learning the product and an expert checking an option should not have to fight the same page.

3. **Low ambiguity**  
   Commands, file names, versions, prerequisites, expected outcomes, and failure states should be explicit.

4. **Scannability**  
   Busy developers skim before they read. Headings, intros, lists, tables, and code blocks should make the page navigable at a glance.

5. **Maintenance**  
   Docs should age gracefully, be easy to update with code changes, and make stale information obvious.

## Non-goals

Do **not** optimize for:
- hype
- marketing language
- exhaustive background on every page
- showing every supported variation in the first document
- clever prose
- giant code dumps with little explanation

## First decide: what kind of page is this?

Never draft before choosing the page type. Keep page types distinct.

### README or docs landing page
Use for orientation and routing.
- Answer: What is this? Who is it for? Where do I start?
- Keep it short.
- Push deep detail into child pages.

### Quickstart
Use for the fastest happy path to a working result.
- One path.
- One main environment.
- Minimal branching.
- Clear prerequisites and a visible success state.

### Tutorial
Use to teach by doing.
- The reader builds something meaningful.
- Include checkpoints and a recap.
- Explain enough for learning, not enough for encyclopedia coverage.

### How-to guide
Use to solve one concrete problem.
- Assumes the reader already knows the basics.
- Focus on outcome, not background theory.

### Reference
Use to answer precise factual questions.
- Syntax, options, defaults, parameters, return values, events, errors, limits, compatibility.
- Dry, complete, easy to scan.

### Explanation / concept page
Use to build mental models.
- Why the system works this way.
- Architecture, trade-offs, invariants, decision rules.
- Link outward to task docs and reference docs.

### Troubleshooting page
Use to diagnose problems by symptom.
- Symptom -> likely cause -> fix -> verify -> prevention.

### Migration guide
Use when versions, APIs, or architecture change.
- Make breakage explicit.
- Show before/after.
- Give a safe order of operations.
- Include rollback guidance when relevant.

## The default workflow

Follow this workflow unless the user asks for something narrower.

### 1) Identify the reader and job
Infer or state:
- reader type: beginner, experienced user, maintainer, integrator, API consumer, platform engineer
- task: learn, set up, integrate, customize, debug, migrate, deploy, contribute
- environment: framework, runtime, package manager, OS, browser, hosting target
- success state: what the reader should be able to do after finishing

If any important fact is missing, do **not** block forever. Make the narrowest reasonable assumption and label it clearly.

### 2) Inventory facts before prose
Collect the facts that often go stale:
- package names
- install commands
- runtime and framework versions
- supported browsers or environments
- environment variables
- URLs, endpoints, ports, callback paths
- permissions, auth requirements, keys, tokens
- build, test, and deploy commands
- breaking changes or constraints

If you cannot verify a fact, avoid inventing it. Use a clearly marked placeholder or assumption.

### 3) Build the page skeleton first
Before writing full paragraphs, create a skeleton with the exact sections the page needs.

Preferred order:
- context
- prerequisites
- steps or body
- verification / expected result
- next steps / related pages

### 4) Write for the first successful run
Every task page should help the reader get one successful outcome as early as possible.

That means:
- front-load the shortest working path
- minimize branching
- postpone advanced options
- prefer one package manager and one framework unless the project truly supports several first-class entry points
- show what success looks like

### 5) Make examples runnable
Examples should be copy-pasteable or easy to adapt.
- Use real filenames and realistic directories.
- Label code fences.
- Keep examples minimal but complete.
- Add comments only where they remove ambiguity.
- If a command is destructive or billable, warn first.
- Show expected output or visible result after important steps.

### 6) Tighten the prose
After the draft exists:
- shorten intros
- split long paragraphs
- convert vague headings into task-based headings
- remove duplicated explanation
- move theory out of procedural pages
- move detail out of landing pages

### 7) Run the review checklist
Use `assets/review-checklist.md` before delivering.

## House style

### Voice
- Use **second person** for the reader.
- Use **active voice** unless passive genuinely improves clarity.
- Use **present tense** for general behavior.
- Sound calm, competent, and direct.
- Be friendly without being chatty.

### Sentence style
- Prefer short, concrete sentences.
- One idea per sentence when possible.
- One main idea per paragraph.
- Avoid filler words such as "simply," "just," "obviously," and "easy."
- Replace vague nouns like "this," "it," and "thing" when they hide the actor or object.

### Headings
- Use **sentence case**.
- Make headings descriptive and task-based.
- Avoid cute headings.
- A reader should understand the page structure by scanning only the headings.

Good:
- `Set up local development`
- `Configure environment variables`
- `Handle webhook retries`

Bad:
- `Before you begin your journey`
- `A few notes`
- `More details`

### Links
- Use descriptive link text.
- Do not use bare "click here" or "read more."
- Link to the specific destination the reader needs next.

### Lists and callouts
- Use numbered steps for ordered actions.
- Use bullets for unordered facts.
- Use warnings only for real hazards.
- Use notes sparingly.

## Length guidance by page type

These are house targets, not hard laws.

### README / docs landing
- Target: 300–900 words.
- Goal: orient and route.
- Deep explanations belong elsewhere.

### Quickstart
- Target: 5–15 steps, usually 500–1,500 words.
- Must include a visible success state.

### Tutorial
- Target: 800–2,500 words.
- Longer is acceptable only if checkpoints keep the reader oriented.

### How-to guide
- Target: as short as the task allows.
- Often 400–1,200 words.

### Reference
- Length is dictated by completeness.
- Optimize for lookup, not for narrative flow.

### Explanation
- Long enough to form a mental model.
- Usually shorter than a tutorial, denser than a quickstart.

### Troubleshooting
- Keep each problem entry short.
- Let readers scan by symptom.

## Page patterns

Use the matching template in `assets/`.

### README or docs landing page pattern
Required elements:
1. Product name and one-sentence value proposition
2. What it does
3. Who it is for
4. Fastest starting point
5. Links to key paths:
   - quickstart
   - concepts
   - how-to guides
   - reference
   - troubleshooting
   - contribution or support
6. Minimal install or local run snippet if appropriate

Avoid:
- long architecture essays
- huge changelogs
- every configuration option
- duplicate content from deeper pages

### Quickstart pattern
Required elements:
1. Outcome
2. Time to complete (optional but recommended)
3. Prerequisites
4. One happy path
5. Expected result
6. Next steps

Rules:
- one package manager if possible
- one deployment target if possible
- explain why a step matters when the reason is not obvious
- prefer a project the reader can run locally

### Tutorial pattern
Required elements:
1. What you will build
2. What you will learn
3. Prerequisites
4. Step-by-step build path
5. Checkpoints after important milestones
6. Recap
7. Next steps

Rules:
- teach progressively
- do not mix every alternative approach into the main flow
- explain cause and effect around each major step

### How-to guide pattern
Required elements:
1. Goal
2. Before you begin
3. Steps
4. Verify the result
5. Variations or related tasks

Rules:
- assume baseline familiarity
- no long conceptual intro
- no encyclopedic reference dump

### Reference pattern
Required elements, as relevant:
- summary
- syntax
- parameters / props / options
- defaults
- return values / events / side effects
- examples
- errors
- compatibility / requirements
- related pages

Rules:
- be complete
- be precise
- be easy to skim
- do not bury behavior in prose if a table or list is clearer

### Explanation pattern
Required elements:
1. The problem space
2. The mental model
3. Important terms
4. How the parts relate
5. Trade-offs and design choices
6. Decision guidance
7. Links to how-to and reference pages

Rules:
- explain *why*
- avoid turning explanation into step-by-step instructions

### Troubleshooting pattern
Required elements:
1. Symptom
2. Likely cause
3. How to verify the cause
4. Fix
5. How to confirm the fix
6. Prevention tips when helpful

Rules:
- index by the words users actually search for
- prefer concrete error messages in headings or subheadings
- keep each entry self-contained

### Migration guide pattern
Required elements:
1. Who should read this
2. What changed
3. Breaking changes
4. Upgrade order
5. Before / after examples
6. Verification
7. Rollback or escape hatch if available

Rules:
- highlight irreversible changes
- be brutally explicit about renamed APIs, removed defaults, and changed behavior

## Web-project specifics

When documenting web software, check these items explicitly.

### Environment and versions
Always state or verify:
- runtime version (for example Node or Bun)
- framework version
- package manager used in examples
- supported browsers when relevant
- OS assumptions when commands differ
- whether examples target local development, staging, or production

### Local development
For setup docs, include:
- install command
- environment variable setup
- seed or sample data steps if required
- dev server command
- local URL
- how to verify the app actually works

### Frontend-specific topics
Cover these when relevant:
- routing model
- client/server boundaries
- rendering mode (SSR, SSG, CSR, streaming, edge)
- styling approach
- state management expectations
- accessibility requirements
- browser support and polyfills
- asset handling

### Backend / API topics
Cover these when relevant:
- authentication and authorization
- rate limits
- pagination
- idempotency / retries
- webhook signing / replay handling
- error format
- local testing or sandbox mode
- CORS or origin constraints
- caching behavior

### Deployment topics
When a page includes deployment:
- separate build-time and runtime configuration
- distinguish secrets from public environment variables
- state platform-specific caveats
- mention rollback, logs, and smoke tests when important

## Code example rules

1. **Solve a real task**  
   Examples should match something the audience actually wants to do.

2. **Start simple**  
   Show the smallest useful example first. Expand later.

3. **Be runnable**  
   Provide the imports, surrounding setup, and file paths the reader needs.

4. **Be easy to scan**  
   Prefer short blocks. Split large examples by step or file.

5. **Label placeholders clearly**  
   Use obvious placeholders like `YOUR_API_KEY` or `your-project-id`.

6. **Do not fake verification**  
   If a result is illustrative rather than guaranteed, say so.

7. **Show expected output when useful**  
   Especially for CLI steps, API responses, generated files, and visible UI changes.

8. **Avoid comment spam**  
   Comment the surprising lines, not every line.

9. **Never hide critical omissions**  
   If code is abbreviated, say exactly what is omitted.

10. **Prefer the project's dominant stack**  
    Do not multiply language or framework tabs unless the product truly supports them equally well.

## What developers tend to like in excellent docs

Use these as quality signals:
- the page tells them where to start
- examples work
- prerequisites are not buried
- the document type is obvious
- learning material and lookup material are separated
- the writer respects their time
- the page shows version or freshness context
- the docs admit limitations and failure modes
- the next step is obvious

## Common anti-patterns

Never ship these on purpose:
- a README that tries to be the entire documentation site
- a quickstart with many branches before the reader gets a first success
- a tutorial that reads like reference
- a reference page missing defaults, errors, or compatibility notes
- commands with hidden prerequisites
- screenshots used instead of copyable text for commands or config
- headings like `Overview`, `Notes`, `Details`, or `More`
- code blocks with no filename, no language, and no surrounding context
- unexplained acronyms or internal terminology
- stale version assumptions
- "works like magic" wording
- burying breaking changes below the fold
- writing as if the tool is the actor when the reader is the actor

## Accessibility and inclusivity rules

- Prefer descriptive link text.
- Provide alt text or a text equivalent for meaningful images.
- Do not rely on screenshots when text or code would be better.
- Keep sentences translation-friendly and jargon-light.
- Explain abbreviations on first use if they are not universal.
- Use examples that do not depend on hidden cultural context.

## Docs-as-code maintenance rules

Prefer documentation that can be maintained like code:
- keep docs near the code when practical
- update docs in the same change as the product behavior
- use review checklists
- keep examples tested or at least plausibly executable
- make "last updated" context visible when the platform supports it
- avoid orphan pages by linking related content

## How to respond in common task modes

### When asked to write a page from scratch
Deliver:
1. the appropriate page type
2. a polished Markdown draft
3. clearly marked assumptions if any important facts are unknown

### When asked to improve existing docs
Do this in order:
1. identify the current page type
2. remove mixed modes
3. tighten structure
4. rewrite for clarity
5. preserve technical meaning
6. call out factual gaps or staleness risks

### When asked to review docs
Return:
- the page type
- the top issues in priority order
- exact rewrite suggestions
- missing sections
- any staleness or trust issues

### When asked to design a docs site
Return:
- audience segments
- entry points
- page types needed
- sitemap
- priority order for authoring
- gaps and risks

## Files in this skill

- `assets/documentation-brief-template.md` — collect facts before writing
- `assets/docs-ia-template.md` — structure a docs site or section
- `assets/docs-home-template.md` — landing page skeleton
- `assets/readme-template.md` — README skeleton
- `assets/quickstart-template.md` — happy-path setup guide
- `assets/tutorial-template.md` — learning-by-doing guide
- `assets/how-to-template.md` — task-focused guide
- `assets/reference-template.md` — API/reference skeleton
- `assets/explanation-template.md` — mental-model page
- `assets/troubleshooting-template.md` — symptom-first troubleshooting
- `assets/migration-guide-template.md` — upgrade/migration page
- `assets/review-checklist.md` — final quality gate
- `references/house-style.md` — voice, sentence style, headings, and page-length rules
- `references/web-project-rules.md` — web-docs checklists, code example rules, and docs-as-code guardrails
- `references/research-notes.md` — why these rules exist

## Final instruction

The best documentation pages feel easy because the writer made a hundred careful choices for the reader:
- what belongs on this page
- what does not
- what comes first
- what to cut
- what to verify
- what to explain
- what to defer

Make those choices deliberately.
