# Lens: Local Code Smells

Find changed values, names, and comments whose local correction makes the code
materially clearer or safer to use.

**Investigate.** Review changed files and their direct callers and callees for
unexplained values, misleading names, hidden side effects, and comments that
contradict behavior. Confirm the remedy is a local rename, named constant, or
comment correction.

**Qualify.** Use P1 for misleading public contracts, P2 for local language that
creates concrete misuse risk, and P3 for confident cosmetic improvement. Apply
the shared output format.

**Examples.**

```text
auth/session.py:L20: [P2 SMELL] misleading name: is_valid mutates and refreshes the token. Callers can trigger an unexpected side effect.
api/client.py:L8: [P1 SMELL] unit mismatch: timeout_ms is interpreted as seconds. Callers provide values at the wrong scale.
```
