# Lens: Pattern Reuse

Find the single strongest place where changed code reimplements an existing
repository helper, abstraction, or convention.

**Investigate.** Search the codebase for an established equivalent and compare
its concern, contract, and caller fit with the new implementation.

**Qualify.** Return the highest-confidence genuine equivalent. Use P1 when the
new version introduces behavioral risk, P2 when reuse removes meaningful
maintenance or drift risk, and P3 for mild normalization. Apply the shared
output format.

**Examples.**

```text
src/pipeline.py:L33: [P2 PATTERN-REUSE] existing helper: this batching loop duplicates utils.batch. Reusing the established helper keeps batching semantics consistent.
```
