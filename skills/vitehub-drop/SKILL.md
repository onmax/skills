---
name: vitehub-drop
disable-model-invocation: true
description: Uploads scoped local files to permanent public URLs and renders scoped source code as temporary Ray.so images. Use when an agent needs a public image or document URL for GitHub content, or a shareable PNG or SVG code image.
---

# ViteHub Drop

Choose one branch. Send only files or source code the user placed in scope, and use the resulting URL only in content the user authorized.

## File

Upload a local file and print its permanent public URL:

```sh
curl --fail-with-body --silent --show-error \
  -F "file=@/absolute/path/to/file.pdf" \
  https://drop.vitehub.dev/api/files |
  jq -er '.url'
```

Copy stdout verbatim; never derive or rewrite the URL from an upload endpoint, Blob key, or framework route. Drop optimizes supported images in the background and stores other files unchanged.

## Code

Send scoped source code to Drop, which renders it through Ray.so, and print the temporary image URL:

```sh
curl --fail-with-body --silent --show-error \
  -H "content-type: application/json" \
  --data '{"code":"const answer: number = 42","language":"typescript","theme":"midnight","format":"png","scale":4}' \
  https://drop.vitehub.dev/api/code |
  jq -er '.url'
```

Copy stdout verbatim. Code image URLs expire after five minutes; download the image before it expires and upload that file through the File branch when a permanent URL is required.

## Code options

Fetch the current case-sensitive IDs from Ray.so before setting `theme` or `language`.

Themes:

```sh
curl -s "https://raw.githubusercontent.com/raycast/ray-so/main/app/(navigation)/(code)/store/themes.ts" |
  grep -oE 'id:[[:space:]]*"[^"]+"' |
  sed -E 's/id:[[:space:]]*"([^"]+)"/\1/' |
  sort -u
```

Languages:

```sh
curl -s "https://raw.githubusercontent.com/raycast/ray-so/main/app/(navigation)/(code)/util/languages.ts" |
  grep -oE '^[[:space:]]*"?[a-zA-Z0-9+#-]+"?[[:space:]]*:[[:space:]]*\{' |
  sed -E 's/^[[:space:]]*"?([^"]+)"?[[:space:]]*:.*/\1/' |
  sort -u
```

- `language` and `theme` accept the IDs printed by those commands.
- `format` accepts `png` (default) or `svg`.
- `scale` affects PNG exports and accepts `2`, `4` (default), or `6`.
