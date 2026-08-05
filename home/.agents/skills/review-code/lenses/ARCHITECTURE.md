# Lens: Architecture

Find concrete opportunities to relocate, regroup, split, or invert code
introduced or made actionable by the reviewed changes. Explore changed files and
their direct callers and callees.

**Qualify.** State the specific structural change, its destination or new shape,
and the concrete benefit it creates. Use P1 when the current shape actively
blocks an imminent change, P2 for demonstrated friction or risk, and P3 for
marginal structural improvement.

**Output.** Apply the shared priority rubric and finding format.

**Examples.**

```text
payments/gateway.py:L55: [P2 ARCHITECTURE] move: retry behavior belongs in the HTTP client module. Centralizing it protects every caller.
auth/middleware.js:L20: [P1 ARCHITECTURE] dependency direction: SessionStore depends on user behavior. Inverting the dependency restores the intended layer direction.
```
