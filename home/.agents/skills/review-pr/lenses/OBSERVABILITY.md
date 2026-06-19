# Lens: Observability

Find places in the changed code and its direct callers/callees (one hop) where runtime visibility is missing or insufficient — for incident response and for ongoing feature-health monitoring. Ask whether a developer or operator could understand what is happening in production. This lens is about visibility, not whether errors are handled correctly. Flag only when the handling is logically adequate but produces no observable signal.

## Examples

`payments/charge.py:L60: blind: charge-failed branch is handled but emits no log or metric. Invisible during an incident. [P2]`

`api/import.js:L22: no signal: new bulk-import feature has no success/failure metric. Can't tell if it works in production. [P2]`

`services/sync.py:L41: slow op: external sync call has no timing metric. Latency regressions go unnoticed. [P3]`

## Process

1. Read the diff. Focus on logic that runs conditionally, handles errors, or crosses a boundary (function call, I/O, external service).
2. For each candidate: ask "if this behaved unexpectedly in production, would I know?" If yes, it passes. If no, it qualifies.
3. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P2**: a blind spot on a path that, when it fails in production, would be hard to diagnose without this signal.
- **P3**: nice-to-have signal on a low-stakes path.

Escalate to P2 when the missing signal would leave a real incident undiagnosable. Do not inflate to P2 just to clear the suppression line.

## Boundaries

Flag only code where a developer or operator would be blind to a real problem in production. Simple, fast, failure-obvious code passes the bar without instrumentation.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
