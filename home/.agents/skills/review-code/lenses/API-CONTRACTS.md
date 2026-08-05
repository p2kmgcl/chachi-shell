# Lens: API Contracts

Find breaking public-interface changes introduced by the reviewed changes. Cover
function signatures, HTTP endpoints, exported types, event schemas, database
contracts, required fields, types, names, and error semantics.

**Investigate.** Trace changed interfaces to identifiable consumers. Confirm how
each consumer uses the previous contract and whether the changes update it.

**Qualify.** Report a finding when a consumed public interface changes and a
real caller experiences a concrete failure or silent behavior change. Apply the
shared priority rubric and output format.

**Examples.**

```text
api/users.py:L14: [P0 API-CONTRACTS] removed: field "email" dropped from UserResponse. Existing callers require it.
routes/orders.js:L88: [P1 API-CONTRACTS] type change: orderId changed from int to string. Arithmetic callers produce incorrect results.
```
