# Pre-Merge Validation Gate

`pr-stack-coordinator` treats `pre-merge-validation` as an adaptive final gate for consumer-facing merge risk: it runs through `vps-connection`, generates or reuses a minimal consumer repro, installs the PR artifact, records a verdict keyed by pull request and head commit, and hands confirmed pull request defects to `pr-refiner`. This is deliberately not generic testing, automatic merging, PR commenting, or source mutation; it exists to reduce post-merge consumer defects that repository-local checks miss.
