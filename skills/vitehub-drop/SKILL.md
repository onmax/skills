---
name: vitehub-drop
description: Uploads a local file and returns its permanent public URL. Use when an agent needs to include a local image or document in GitHub content.
---

# ViteHub Drop

The input must be a file the user placed in scope. Run:

```sh
curl --fail-with-body --silent --show-error \
  -F "file=@/absolute/path/to/file.pdf" \
  https://drop.vitehub.dev/api/files |
  jq -er '.url'
```

The command prints the permanent public URL returned by ViteHub Blob as soon as the file is stored. Copy stdout verbatim; never derive or rewrite it from an upload endpoint, Blob key, or framework route. Drop optimizes supported images in the background and stores other files unchanged. Use the URL in GitHub content the user explicitly authorized.
