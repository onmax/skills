#!/usr/bin/env node

import { execFile } from 'node:child_process'
import { constants } from 'node:fs'
import { chmod, mkdtemp, open, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { setTimeout as sleep } from 'node:timers/promises'
import { promisify } from 'node:util'

const execFileAsync = promisify(execFile)
const email = 'admin@quiver.dk'

function previewUrl(value, path = '/') {
  const prNumber = Number(value)
  if (!Number.isSafeInteger(prNumber) || prNumber < 1)
    throw new TypeError('PR number must be a positive integer')
  if (typeof path !== 'string' || !path.startsWith('/'))
    throw new TypeError('Preview path must start with /')

  const origin = new URL(`https://pr${prNumber}-demo.preview.quiver.dk`)
  const target = new URL(path, origin)
  if (target.origin !== origin.origin)
    throw new TypeError('Preview path must stay on the PR preview origin')
  return target.href
}

async function readPassword(prNumber) {
  try {
    const { stdout } = await execFileAsync('kubectl', [
      'get',
      'secret',
      'directus-admin-secret',
      '--namespace',
      `quiver-demo-pr${prNumber}-test`,
      '--output',
      'go-template={{index .data "admin-password" | base64decode}}',
    ], {
      encoding: 'utf8',
      maxBuffer: 64 * 1024,
      timeout: 15_000,
      windowsHide: true,
    })

    if (stdout.trim())
      return stdout.trim()
    throw new Error('empty-secret')
  }
  catch (error) {
    if (error?.code === 'ENOENT')
      throw new Error('kubectl is unavailable')
    if (error?.killed || error?.signal)
      throw new Error('kubectl timed out while reading preview credentials')

    const stderr = String(error?.stderr ?? '')
    if (/forbidden|unauthorized/i.test(stderr))
      throw new Error('kubectl cannot access preview credentials')
    if (/not found/i.test(stderr) || error?.message === 'empty-secret')
      throw new Error(`Preview credentials do not exist for PR ${prNumber}`)
    if (/unable to connect|connection refused|i\/o timeout/i.test(stderr))
      throw new Error('kubectl cannot reach the preview cluster')
    throw new Error(`Preview credentials are unavailable for PR ${prNumber}`)
  }
}

async function handOffLogin(prNumber, path) {
  const url = previewUrl(prNumber, path)
  const directory = await mkdtemp(join(tmpdir(), 'portal-preview-login-'))
  const fifoPath = join(directory, 'credential.fifo')
  let password = ''

  try {
    password = await readPassword(prNumber)
    await execFileAsync('mkfifo', [fifoPath])
    await chmod(fifoPath, 0o600)
    process.stdout.write(`${JSON.stringify({ fifoPath, url })}\n`)

    const deadline = Date.now() + 120_000
    let fifo
    while (!fifo && Date.now() < deadline) {
      try {
        fifo = await open(fifoPath, constants.O_WRONLY | constants.O_NONBLOCK)
      }
      catch (error) {
        if (error?.code !== 'ENXIO')
          throw error
        await sleep(100)
      }
    }

    if (!fifo)
      throw new Error('Preview login handoff expired')

    try {
      await fifo.writeFile(JSON.stringify({ email, password }))
    }
    finally {
      await fifo.close()
    }
  }
  finally {
    password = ''
    await rm(directory, { force: true, recursive: true })
  }
}

function selfCheck() {
  if (previewUrl(42, '/planning-events') !== 'https://pr42-demo.preview.quiver.dk/planning-events')
    throw new Error('Preview URL check failed')

  let rejectedUnsafePath = false
  try {
    previewUrl(42, '//example.com')
  }
  catch {
    rejectedUnsafePath = true
  }
  if (!rejectedUnsafePath)
    throw new Error('Unsafe preview path was accepted')

  process.stdout.write('preview-login self-check passed\n')
}

async function main() {
  const [prNumber, path = '/'] = process.argv.slice(2)
  if (prNumber === '--self-check')
    return selfCheck()
  if (!prNumber)
    throw new Error('Usage: preview-login.mjs <pr-number> [path]')
  await handOffLogin(prNumber, path)
}

main().catch((error) => {
  process.stderr.write(`${error instanceof Error ? error.message : 'Preview login failed'}\n`)
  process.exitCode = 1
})
