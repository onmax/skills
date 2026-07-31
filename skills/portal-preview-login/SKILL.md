---
name: portal-preview-login
description: Authenticates Browser to a Quiver Portal pull-request preview and opens the requested route. Use when a `pr<number>.demo.quiver.dk` preview displays the Portal login page.
---

# Portal Preview Login

Sign into one Portal PR preview through its normal login form. Browser owns navigation and interaction; the helper only passes the preview credential from the shell context that can access Kubernetes.

## Steps

1. Use Browser to open `https://pr<number>.demo.quiver.dk<path>`, preserving the requested same-origin path or using `/` when none was requested. If the authenticated app is already visible, stop without resolving credentials. If Browser is unavailable, report the blocker instead of substituting standalone browser automation.

2. If the login form appears, run `scripts/preview-login.mjs <pr-number> <path>` from this skill's installed directory with a short yield. Keep the process alive and retain its metadata-only JSON containing `url` and `fifoPath`. If sandbox networking blocks `kubectl`, request the normal command escalation.

3. Resolve unique email, password, and **Sign in** locators before reading the FIFO. Then, in one browser-control call, read and parse the FIFO with `node:fs/promises.readFile`, UTF-8 encoding, and `AbortSignal.timeout(5000)`; fill both fields; overwrite the password with an empty string; drop the object reference; and click **Sign in**. Do not inspect the DOM or take a snapshot or screenshot between filling and submitting because browser output can serialize password values. Never emit, log, interpolate, or copy the credential into model-authored text.

4. Navigate to the returned `url` after authentication because Portal versions may redirect sign-in elsewhere. Completion means Browser shows that path with the authenticated app shell and no login form.

## Boundaries

- Leave Portal's cookies and browser storage opaque; use the visible login flow instead of cookie extraction or injection.
- Resolve only `quiver-demo-pr<number>-test/directus-admin-secret`. The mode-0600 FIFO is short-lived and one-use; credential bytes are never printed or written to a regular file. Use no PR-comment or log fallback.
- Keep previews read-only apart from creating the browser session. A missing or unhealthy preview is a blocker; do not scale, deploy, or recreate it through this skill.
- Report only the target URL and visible result. On failure, preserve the page for diagnosis and retry only with a new hypothesis.

Run `scripts/preview-login.mjs --self-check` after changing the helper.
