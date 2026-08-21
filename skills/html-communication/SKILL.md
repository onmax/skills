---
name: html-communication
description: Use when the user asks to communicate through an HTML document, or if they mention "HTML" with no additional context.
---

# HTML communication

Create one HTML document for a human to read outside the terminal.

## Document

- Keep the file self-contained and no larger than 512 KB.
- Write it like a document, not a landing page. Favor dense, scannable content over decorative framing or marketing copy.
- Use responsive semantic HTML, inline CSS, and inline SVG. Keep the document useful without JavaScript. Add a small inline script only when interaction helps the reader.
- Keep styles, scripts, fonts, and images inside the file. External links are fine.
- Keep secrets, private URLs, and local filesystem paths out of published content.
- For UI variants, render the actual styled options, label them `A`, `B`, `C`, and place them together for comparison.
- Reuse the same absolute path across revisions so a published URL can stay stable.

## Delivery

Write the file to the OS temporary directory unless the user requests a repository path.

For local HTML, return the absolute file path without uploading it.

When the user asks to host it, share a link, or use Postplan, run:

```sh
npx postplan upload <absolute-file-path>
```

Return the URL printed by the command. Upload only the requested document. Never claim it is hosted before the command succeeds.

Fix a local validation error and retry once. If authentication, the network, or the service still blocks the upload, report the blocker and stop. Open the document in a browser only when the user asks.
