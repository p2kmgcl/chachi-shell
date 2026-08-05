# Lens: Error Handling

Find changed error paths whose detection, propagation, or recovery leaves
callers misinformed or system state inconsistent.

**Investigate.** Follow each changed error path from origin to final handler
through direct callers and callees. Confirm the failure signal, information
available to the caller, cleanup behavior, and resulting state.

**Qualify.** Report structurally incorrect handling for realistic failures.
Apply the shared priority rubric and output format.

**Examples.**

```text
db/write.py:L52: [P1 BUG-ERROR-HANDLING] detection: the write-failure return value is ignored. The caller continues as if persistence succeeded.
sync/worker.js:L88: [P0 BUG-ERROR-HANDLING] recovery: the error path retains the acquired lock. Subsequent workers deadlock.
```
