# Lens: Pattern Extraction

Find the single strongest repeated pattern introduced or extended by the
reviewed changes that becomes clearer and safer as one named reusable unit.

**Investigate.** Compare repeated logic and inline idioms across the diff and
nearby code. Confirm the pattern solves the same recurring concern at each
location.

**Qualify.** Return the highest-confidence candidate. Use P2 when extraction
removes meaningful repetition or prevents copies from diverging and P3 for
minor reusable repetition. Apply the shared output format.

**Examples.**

```text
services/payment.py:L12: [P2 PATTERN-EXTRACT] extract: retry logic is repeated at three call sites. A shared with_retry function prevents divergent behavior in related paths.
```
