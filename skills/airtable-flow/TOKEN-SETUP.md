# Airtable mutation token setup

Use this branch only when `airtable-mcp whoami --profile quiver-mutations` cannot authenticate. Normal task work must remain browser-free.

1. Invoke the `browser` skill and open Airtable's [personal access token guide](https://support.airtable.com/v1/docs/creating-personal-access-tokens), then open [Create token](https://airtable.com/create/tokens).
2. Help Maxi create `Quiver Airtable Flow CLI` with access limited to the Quiver User feedback base and these scopes:
   - `data.records:read`
   - `data.records:write`
   - `data.recordComments:read`
   - `data.recordComments:write`
   - `schema.bases:read`
   - `workspacesAndBases:read`
3. Keep the secret out of chat, tool output, shell history, and project files. Ask Maxi to copy the newly revealed PAT, then paste it only into `airtable-mcp configure --profile quiver-mutations` in his local terminal.
4. Verify the profile with `airtable-mcp whoami --profile quiver-mutations`, schema discovery for the configured base, and one read-only record query. Do not test mutation access by changing a real task; the first mapped lifecycle effect is the write proof.

Setup is complete only when the named profile authenticates, can read schema and one Task, and no token value was exposed or stored in the project.
