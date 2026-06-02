# Lens: Observability

Your goal: identify places in the changed code (and its direct callers/callees) where **observability
is missing or insufficient** — both for incident response and for ongoing monitoring of feature
health. You are not asking for logs everywhere — you are asking whether a developer or operator
could understand what is happening in production, now and over time.

This lens is about runtime visibility, not whether errors are handled correctly. Do not flag an
error path solely for being ignored, not propagated, or leaving the system in a bad state. Flag here
only when the handling is logically adequate but produces no observable signal.

## Scope

Changed files and their direct callers and callees (one hop).

## What qualifies

**Incident response**
- A decision point, branch, or state transition with no log or metric — one where you'd be blind
  during an incident
- An error that is caught and handled correctly but leaves no trace (no log, no metric, no alert)
- A slow or expensive operation (I/O, external call, heavy computation) with no timing or count metric
- Existing instrumentation that logs the wrong level, the wrong fields, or misleading messages

**Feature monitoring**
- A new feature or behavior with no metric to track whether it's working as intended over time
- A success path that produces no signal — you can't tell from the outside whether it ran or not
- A meaningful user action or business event introduced by this PR with no tracking
- A rate, ratio, or threshold that matters operationally but has no dashboard or alert backing it

## What does not qualify

- Logging for its own sake — code that is simple, fast, and failure-obvious doesn't need a log
- Trace-level verbosity in hot paths
- Instrumentation that already exists and is adequate
- Errors that are not correctly handled (ignored, not propagated, no recovery)

## Process

1. Read the diff. Focus on logic that runs conditionally, handles errors, or crosses a boundary
   (function call, I/O, external service).
2. For each candidate: ask "if this behaved unexpectedly in production, would I know?" If yes,
   discard. If no, it qualifies.
3. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
4. Discard anything subjective or speculative.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- One-sentence description of what's unobservable and why
- Why it matters operationally (one sentence)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.
