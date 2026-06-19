# Lens: Error Handling Quality

Find error paths in the changed code and its direct callers/callees (one hop) whose logic is incorrect: when something goes wrong, does the code detect it, propagate it faithfully, and leave the system in a consistent state? This lens is about the **shape of the error handling** — detection, propagation, recovery — not whether one specific input crashes and not runtime visibility. Flag only when the handling structure itself is wrong for realistic failure modes.

## Examples

`db/write.py:L52: detection: return value signaling write failure is never checked. Caller proceeds as if it succeeded. [P1]`

`sync/worker.js:L88: recovery: lock acquired but not released on the error path. Subsequent runs deadlock. [P0]`

`api/client.py:L34: propagation: bare except swallows the real error and returns None. Root cause becomes untraceable. [P2]`

## Process

1. Read the diff. Trace every error path introduced or modified.
2. For each path: follow it from origin to final handler. Ask whether the error is detected, whether the caller gets useful information, and whether the system ends up in a consistent state.
3. Apply the priority rubric from `PRIORITIES.md`.

## Boundaries

Flag only error paths where the logic is genuinely incorrect for realistic failure modes.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
