# Documentation Writing Reference

Use this reference for a full draft or a material rewrite. The rules are portable; repository instructions still decide Markdown dialect, components, frontmatter, code style, and product vocabulary.

## Choose the page shape

### Tutorial

Promise one observable result and build the shortest working path to it. A beginner should encounter a concept only when it changes the next step. Finish with the result, then link to optional features or deeper explanations.

### Guide

Start from a concrete task and the conditions that change the approach. Keep alternatives beside the decision they affect. Use numbered steps only for a real sequence.

### Concept

Define the subject through what it changes in the system. Explain its nearest boundary and alternative, then use one realistic scenario to make the distinction visible.

### Reference

Optimize for lookup. Use stable headings, tables for parallel options, exact defaults, types, constraints, and short examples. Keep tutorials and architectural persuasion elsewhere.

### Troubleshooting

Lead with the visible symptom and the fastest discriminating check. Move from evidence to cause to correction, and end with a verification that distinguishes a fix from a hidden failure.

## Build the page around reader decisions

Use only the questions the page earns:

1. What is this, and what result does it produce?
2. When should I use it instead of the nearest alternative?
3. What can block me before I start?
4. What few mechanisms must I understand to use it correctly?
5. What limitation or failure will change my choice?
6. What will I observe when it works?
7. What is the next choice after this page?

These questions are a composition aid, not a fixed section template. A heading earns its place when removing it would merge two different reader decisions.

## Shape prose by ideas

Give each paragraph one complete move: claim, mechanism, and consequence. Split when the claim changes, not after a fixed number of sentences. A one-sentence paragraph can close a boundary or turn the explanation; a longer paragraph can keep connected reasoning intact.

Vary cadence with the reasoning. Use a short sentence for a firm constraint. Let causal and conditional explanations breathe through connected clauses. Carry context forward with a concrete noun or consequence rather than a generic transition.

Lists hold parallel facts. Numbered lists hold sequences. Tables settle repeated-field comparisons. Keep connected reasoning in prose so the reader can see why one fact leads to another.

## Apply a Simplified Technical English clarity pass

Borrow these principles from ASD-STE100 without treating public developer documentation as a controlled-language manual:

- Use one familiar word for one meaning throughout the page.
- Prefer the simplest accurate verb, such as `add`, `create`, `read`, `return`, `run`, `start`, `use`, or the exact runtime operation.
- Put a condition before the instruction or result it controls.
- Give one instruction per sentence; add a second clause only for its direct result.
- Turn nominalizations into verbs: “ViteHub discovers the Definition,” not “Definition discovery occurs.”
- Keep canonical technical nouns. Define one beside its first practical use, then use the same noun consistently.

This pass targets ambiguity, not personality. Keep contractions and natural sentence rhythm where they help the page sound like a knowledgeable person explaining the work.

## Replace abstract agent language

Describe what happens instead of assigning qualities or responsibilities to software.

| Abstract | Concrete |
| --- | --- |
| “The framework owns the server integration.” | “ViteHub discovers the Definition during the build.” |
| “The invocation produces an observable result.” | “The request returns the greeting.” |
| “Use application-owned logic.” | “Write a function that returns a fixed response.” |
| “This preserves the invocation boundary.” | “Keep the Definition and the `runAgent()` call.” |
| “The Driver provides an inspectable execution path.” | “The Driver returns text without calling a provider.” |

Watch for clusters such as _boundary_, _surface_, _ownership_, _plumbing_, _path_, _shape_, _flow_, and _observable_. These can be exact domain terms, but when they stand in for an operation, replace them with who does what and what the reader sees.

## Make examples and limitations earn their space

An example should settle a choice, prove a distinction, or produce the page's promised result. Prefer a plausible name, request, file, and response over a toy fragment that repeats the preceding sentence.

State limitations with the same confidence as the happy path. Distinguish intended behavior from a known rough edge, give the practical consequence, and include a workaround only when current evidence supports it.

## Open and close with purpose

Open with the subject in ordinary language, the action it performs, and the immediate result. For a getting-started page, mention optional extensions only to orient the reader; teach them after the first result works.

Close on evidence or direction. Show what now works, which adjacent choice comes next, or what condition calls for another approach. A generic summary repeats text the reader has already understood.

## Revision questions

- Could a newcomer explain the first paragraph without borrowing its nouns?
- Does every unfamiliar term change an immediate action?
- Can the reader picture each verb happening?
- Does each example have an input, action, and visible result?
- Are qualifications beside the claims they limit?
- Do several paragraphs or sentences share the same size and shape?
- Can any section disappear without weakening the promised result?

## Sources

This approach combines recurring composition patterns from Matt Pocock's public skill documentation with an adapted subset of [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/). It does not copy Matt's project-specific templates or claim formal STE compliance.

