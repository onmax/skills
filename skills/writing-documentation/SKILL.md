---
name: writing-documentation
description: Writes and rewrites developer documentation around the reader's goal, with concrete technical English and verified examples. Use for tutorials, guides, concepts, references, and troubleshooting pages.
---

# Writing Documentation

Write the shortest accurate path from what the reader knows to what they came to do. Repository instructions own framework syntax, frontmatter, components, and formatting conventions; this skill owns the explanation.

Read [REFERENCE.md](REFERENCE.md) when drafting or materially restructuring prose. For a small factual edit, preserve the page's established voice and change only the necessary text.

## Process

1. **Set the promise.** Name the reader, what they already know, and the result the page must deliver. For a rewrite, decide whether the user authorized a new composition or only a prose edit. Do not preserve the old structure when a fresh composition is authorized.

2. **Verify the path.** Check current source, types, tests, or primary documentation for every load-bearing claim. Run changed examples when practical. Separate facts from assumptions before drafting.

3. **Choose the minimum concepts.** Work backward from the promised result. Introduce a term when it changes the reader's next action; defer adjacent architecture and optional features to links after the main path works.

4. **Compose by reader decisions.** Open with the subject, what it does, and the nearest useful boundary. Order sections by the questions the reader must answer, not by the implementation's file layout. Make headings state the action, distinction, or result of the section.

5. **Draft in concrete technical English.** Name the developer or runtime action and its visible result. Keep canonical product terms, but connect them with familiar verbs. Apply the Simplified Technical English clarity pass in [REFERENCE.md](REFERENCE.md) without claiming formal ASD-STE100 compliance.

6. **Make examples prove the page.** Give each example a plausible input, action, and observable output. Explain why the code exists before showing it. Keep code labels and project syntax consistent with repository conventions.

7. **Revise from scratch once.** Read only the promise and the draft, then remove concepts that arrived before they were needed, abstract responsibility language, repeated conclusions, decorative examples, and generic transitions. Read the prose aloud for repeated sentence shapes.

## Completion

The page is complete when:

- the intended reader can reach the promised result without learning incidental architecture;
- the opening explains the subject in ordinary language before expanding its options;
- each section changes what the reader understands or does next;
- every technical claim and changed example has current evidence;
- paragraphs break when the idea changes, with causal reasoning kept together;
- verbs describe concrete developer or runtime actions instead of abstract qualities or ownership;
- conditions and limitations appear beside the claims they qualify;
- the ending provides proof or the next relevant choice instead of recapping the opening;
- repository-specific syntax and formatting checks pass.

