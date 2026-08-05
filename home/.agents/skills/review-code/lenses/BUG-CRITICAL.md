# Lens: Critical Bugs and Regressions

Find crashes, data corruption, data loss, and regressions on primary execution
paths introduced by the reviewed changes.

**Investigate.** Read the complete changed files, trace callers and surrounding
state, and compare relevant behavior before and after the changes. Confirm
realistic reachability, ownership by the changes, and concrete impact.

**Qualify.** Report high-confidence failures on normal usage paths. Apply the
shared priority rubric and output format.

**Examples.**

```text
orders/checkout.py:L44: [P0 BUG-CRITICAL] crash: empty carts divide by zero on the primary checkout path. Checkout terminates unexpectedly.
auth/session.js:L12: [P0 BUG-CRITICAL] regression: logout leaves the server token active. A logged-out session remains usable.
```
