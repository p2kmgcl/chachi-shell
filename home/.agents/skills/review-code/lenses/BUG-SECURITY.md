# Lens: Security

Find exploitable weaknesses introduced or enabled by the reviewed changes,
including injection, authorization failures, sensitive-data exposure, insecure
defaults, path traversal, and credential handling.

**Investigate.** Trace untrusted inputs to sensitive operations, inspect
authorization seams and surrounding middleware, and confirm a realistic exploit
path introduced by the change.

**Qualify.** Report high-confidence findings with a concrete attacker action and
impact. Apply the shared priority rubric and output format.

**Examples.**

```text
api/search.py:L23: [P0 BUG-SECURITY] injection: user input is interpolated into raw SQL. A crafted query can read arbitrary tables.
config/storage.py:L8: [P0 BUG-SECURITY] insecure default: new storage is publicly readable. Unauthenticated users can list uploaded files.
```
