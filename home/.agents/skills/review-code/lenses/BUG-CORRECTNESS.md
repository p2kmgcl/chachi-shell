# Lens: Correctness

Find realistic inputs where changed code completes but produces an incorrect
result. Cover conditionals, boundaries, state transitions, nullable values,
operators, and uncommon valid inputs. Critical-path crashes and data loss belong
to the critical-regression lens.

**Investigate.** Establish intended behavior from contracts, types, invariants,
and callers. Trace varied inputs through the changed implementation and confirm
the divergence was introduced by the reviewed changes.

**Qualify.** Report high-confidence, reachable cases with a specific wrong
result and consequence. Apply the shared priority rubric and output format.

**Examples.**

```text
utils/date.py:L22: [P1 BUG-CORRECTNESS] off-by-one: range excludes the final day of the month. Monthly reports omit valid data.
billing/tax.py:L91: [P2 BUG-CORRECTNESS] boundary: tax bracket uses > where equality belongs in the higher bracket. Boundary values receive the wrong rate.
```
