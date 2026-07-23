#!/usr/bin/env node

import { readFile } from "node:fs/promises"
import { basename } from "node:path"

const origin = process.env.DROP_ORIGIN || "https://drop.vitehub.dev"
const input = process.argv[2]
if (!input) throw new Error("Usage: upload-image.mjs <file-path|->")

const bytes = input === "-" ? Buffer.concat(await Array.fromAsync(process.stdin)) : await readFile(input)
const filename = input === "-" ? "file" : basename(input)
const form = new FormData()
form.set("file", new File([bytes], filename))

const uploadResponse = await fetch(new URL("/api/files", origin), {
  body: form,
  method: "POST",
  signal: AbortSignal.timeout(30_000),
})
if (!uploadResponse.ok) throw new Error(await uploadResponse.text())

const { url } = await uploadResponse.json()
if (typeof url !== "string") throw new Error("Drop did not return a file URL.")
const publicUrl = new URL(url, origin)
if (publicUrl.origin !== new URL(origin).origin || !publicUrl.pathname.startsWith("/i/")) {
  throw new Error("Drop did not return a public /i/ URL.")
}
console.log(publicUrl.href)
