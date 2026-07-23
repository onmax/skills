---
name: vitehub-drop
description: Uploads a local file and returns its permanent public URL. Use when an agent needs to include a local image or document in GitHub content.
---

# ViteHub Drop

The input must be a file the user placed in scope. Resolve the bundled script relative to this `SKILL.md`, then run:

```sh
node "<skill-directory>/scripts/upload-image.mjs" "/absolute/path/to/file.pdf"
```

The script sends one `file` field to `/api/files` and prints a permanent `https://drop.vitehub.dev/i/<id>` URL as soon as Blob stores it. Copy stdout verbatim; never derive or rewrite it from the upload endpoint, Blob key, or framework route. The script rejects any response outside Drop's `/i/` public route. Drop optimizes supported images in the background and stores other files unchanged. Use the URL in GitHub content the user explicitly authorized.
