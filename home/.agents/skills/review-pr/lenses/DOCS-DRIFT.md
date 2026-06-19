# Lens: Documentation Drift

Find existing documentation that this PR has made incorrect or misleading: comments, docstrings, READMEs, changelogs, architecture docs, or any prose that described reality accurately before this PR and no longer does. This lens is about drift, not gaps — docs live far from the code they describe, so cast wide.

## Examples

`README.md:L40: drift: documents --timeout default as 30s. This PR changed it to 10s. [P2]`

`api/client.py:L12: drift: docstring says "returns None on miss" but the PR now raises KeyError. Callers following the doc will break. [P1]`

`docs/architecture.md:L88: drift: diagram shows the worker reading from the queue directly. This PR moved it behind the dispatcher. [P3]`

## Process

1. Read the diff. List every behavioral or interface change: new parameters, changed defaults, removed behavior, renamed things, altered contracts.
2. Search the repository for documentation referencing the changed symbols, files, or concepts.
3. For each doc found: check whether it still accurately describes reality post-PR.
4. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P1**: the stale doc will lead a caller to write broken code.
- **P2**: the doc misleads, but a reader would likely catch the discrepancy against the code.
- **P3**: cosmetic staleness with no real risk of misleading anyone.

Do not inflate to P2 just to clear the suppression line.

## Boundaries

Flag only docs that were accurate before this PR and are now incorrect or misleading. This lens is about drift, not gaps.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
