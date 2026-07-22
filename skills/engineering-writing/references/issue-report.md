# Issue report

Write for the engineer deciding whether and where to fix an observed problem.

## Content order

1. Open with the unexpected user-visible or system-visible result and the smallest context needed to recognize it.
2. State the expected result plainly.
3. Give the confirmed root cause or ownership boundary when known. If it is only suspected, label it and state the missing proof.
4. Link the original report and add only the screenshot, log fact, or code path that helps the engineer act.
5. End with the observable result that means the issue is fixed.

Use the destination's fields instead of recreating them as headings. A short issue may be one compact paragraph plus evidence links.

Do not ask for or add a minimal reproduction by default. Add reproduction steps, environment, version, runtime stage, or ownership metadata only when the existing report, logs, or screenshot do not make the problem actionable.

## Evidence

- Prefer the actual wrong result over a long explanation of how it was discovered.
- Use one screenshot when it establishes a visual failure quickly, but keep the current and expected results complete in text. Add an expected reference only when the intended state is visually ambiguous.
- Keep exact errors, values, dates, IDs, and any necessary verification steps as searchable text.
- Link the original report or review near the claim it supports.

## Avoid

- Investigation chronology, ranked hypotheses that have already been resolved, repeated infrastructure details, or a command log.
- Presenting a downstream symptom as the root cause.
- Assigning an owner when the evidence only identifies a component or seam.
- Hiding uncertainty behind confident wording.

## Example shape

```md
Planning-event effects show `0 pcs.` even when the event has a non-zero rule and applied forecast rows. The card should show the calculated event impact.

The impact endpoint currently calculates only from raw forecast rows. In this preview those rows are absent, so it returns no items and Portal renders zero. The fix belongs in the preview-data or forecasting path, not the display component.

Original report: <link>
Done when: an active non-zero rule returns and displays a non-zero impact in the same setup.
```
