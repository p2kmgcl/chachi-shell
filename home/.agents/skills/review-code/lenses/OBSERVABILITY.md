# Lens: Observability

Find changed production paths where developers or operators lack the signals
needed to understand failures or feature health.

**Investigate.** Examine conditional logic, handled failures, I/O, and external
calls in changed files and their direct callers and callees. Identify the logs,
metrics, traces, or events that currently reveal runtime behavior.

**Qualify.** Report P2 when a real production incident would remain difficult to
diagnose and P3 for useful low-stakes visibility. Apply the shared output
format.

**Examples.**

```text
payments/charge.py:L60: [P2 OBSERVABILITY] blind failure: failed charges are handled without an operational signal. Incident responders cannot identify the failure rate.
api/import.js:L22: [P2 OBSERVABILITY] feature health: bulk import emits no success or failure measure. Operators cannot assess production reliability.
```
