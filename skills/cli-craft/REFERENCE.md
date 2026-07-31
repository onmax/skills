# CLI Contract Reference

Load only when one of these pressures appears. The contract stays primary; tools and presentation serve it.

## Output and composition

Choose the smallest stable automation surface that matches the data:

- **Human output** may use labels, tables, progress, and color. Treat it as presentation unless documented as stable.
- **Plain output** suits one scalar or an established line protocol.
- **JSON** suits one record or bounded collection. Preserve absent data as `null` or omission according to a documented schema; keep real zero values distinct.
- **NDJSON** suits unbounded or incremental records.
- **Streams or bytes** should preserve the existing protocol instead of being wrapped for aesthetics.

Once an automation mode is documented, stdout is its API. Emit only the payload there; send diagnostics to stderr. Suppress prompts, progress, tips, and ANSI decoration. Verify the payload through a pipe with the real executable.

TTY-aware presentation can improve human output, but TTY detection must never be the only way to reach complete behavior. Honor explicit color controls and established `NO_COLOR` conventions when the repository supports them.

### Compact contract example

For `tool inspect <target> --json`:

- `<target>` is required; `--json` selects the stable automation schema.
- stdout contains exactly one JSON object.
- stderr contains diagnostics and authentication guidance.
- status `0` means a result was produced, `2` means the invocation was invalid, and another documented non-zero status represents operation failure.
- JSON mode is fully non-interactive, and this inspection command is read-only.

One boundary proof can invoke the real executable, redirect both streams, parse stdout, assert empty stderr on success, and repeat with a missing target to assert the documented failure status and diagnostic.

## Interaction, secrets, and effects

Prompts are an explicit user-interface branch. Provide flags, stdin, environment, or protected configuration for unattended use, define cancellation behavior, and give cancellation a deliberate status.

Keep secrets out of argv, stdout, debug logs, and committed files. Prefer protected environment/configuration, stdin, keychains, or locally permissioned session files according to the platform. Redact diagnostics and fixtures.

Classify effects by consequence:

- A directly named, reversible action may execute immediately and report resulting state.
- Broad local mutation benefits from preview, an explicit force flag, or refusal when the target is unsafe.
- Destructive, remote, financial, account, or publication effects require conspicuous intent and the authority appropriate to that system.

For network commands, make timeout, retry, and partial-success behavior observable. Retry only operations whose idempotency is understood. Handle signals and cleanup where interrupted work can leave durable state.

## Arguments, parsers, and configuration

Manual parsing is sufficient when the surface is small and its ambiguity is tested. A declarative parser earns its cost when the CLI needs nested commands, generated help, typed coercion, enum validation, lazy loading, or an existing repository convention.

Keep the argument contract in one source of truth when generated help or types depend on it. Validate required and allowed values before domain effects begin.

Add configuration machinery only after a second real source exists. Resolve defaults, discovered project state, config files, environment, and CLI overrides once, with documented precedence, then pass one resolved options object into the operation.

## Callable core and process edge

Keep `argv`, terminal rendering, and process termination at the executable edge when domain work needs reuse, multiple output modes, direct testing, or reliable cleanup. The core may remain in the same file; this is a behavioral seam, not a directory requirement.

Programmatic execution should return data or throw/return a typed failure. The process edge translates that result into output and status. Test both layers when both are public.

## Executable proof

Scale the proof set to the contract:

- parser or handler tests for input semantics;
- structured-output parsing or snapshots for stable automation schemas;
- subprocess invocation for stdout, stderr, status, signals, and environment;
- fixture or temporary-directory tests for filesystem effects;
- an independent read or query for remote resulting state;
- generated-help assertions when help comes from the command schema;
- compatibility matrices only for real runtime, platform, or package-manager promises.

At least one check must invoke the actual executable path. Imported-function tests cannot prove shebangs, `bin` wiring, packaging, stream routing, or exit behavior.

## Packaging and distribution

Follow the target ecosystem and repository convention. Verify the artifacts that make the command runnable: executable declaration or `bin`, shebang where required, published file list, module format, bundled versus external dependencies, runtime floor, and installation instructions.

Test the packaged or installed command when distribution is in scope. Verify on the oldest supported runtime when compatibility is claimed. Measure startup before optimizing it.

## Compatibility

Treat documented command names, flags, defaults, stable output fields, stream routing, and status semantics as public API. For an established CLI, classify the change before implementation:

- additive behavior can usually ship directly;
- changed meanings need migration wording and focused regression coverage;
- removed or renamed inputs need the repository's deprecation strategy;
- machine-output schema changes need an explicit compatibility decision.

Human presentation may evolve more freely when it is not documented as stable. Preserve quiet Unix behavior where silence plus status is the established contract.

## Evidence lineage

- [`citypaul/.dotfiles@cli-design`](https://skills.sh/citypaul/.dotfiles/cli-design) supplies broad stream, interaction, secret, and mutation vocabulary.
- [`dart-lang/skills@dart-build-cli-app`](https://skills.sh/dart-lang/skills/dart-build-cli-app) and [`posit-dev/skills@r-cli-app`](https://skills.sh/posit-dev/skills/r-cli-app) show why implementation recipes remain ecosystem-specific.
- [`antfu-collective/ni`](https://github.com/antfu-collective/ni) and [`antfu-collective/taze`](https://github.com/antfu-collective/taze) demonstrate callable operations, explicit interaction, configuration resolution, scripting output, and executable tests.
- [`unjs/citty`](https://github.com/unjs/citty), [`unjs/giget`](https://github.com/unjs/giget), and [`unjs/changelogen`](https://github.com/unjs/changelogen) demonstrate typed contracts, thin process adapters, proportional mutation guards, and differing valid parser and output choices.
