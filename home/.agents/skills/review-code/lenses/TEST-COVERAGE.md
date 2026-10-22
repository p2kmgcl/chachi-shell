# Lens: Test Coverage

Find meaningful test gaps, false confidence, implementation coupling, and
redundancy introduced by the reviewed changes.

**Investigate.** Apply the shared [testing guidance](../../write-code/testing.md)
for test value, boundaries, expectations, and retention. Map supported behavior
and plausible regressions to existing protection; an uncovered branch alone is
not a finding. Check for expected values copied from production logic and
assertions that cannot detect the claimed regression.

**Categories.** Use `missing` for realistic uncovered regressions, `coupled` for
tests tied to private structure or collaborator wiring, `redundant` for tests
that add no distinct protection, and `false-confidence` for assertions that do
not establish the claimed behavior.

**Qualify.** Use P2 when a realistic regression can ship silently or an
important test creates false confidence, and P3 for a minor gap or low-stakes
test smell. Apply the shared output format.

**Examples.**

```text
parser/cron.py:L40: [P2 TEST-COVERAGE] missing: the new leap-year branch has no behavioral test. A date regression can ship silently.
tests/test_orders.py:L88: [P2 TEST-COVERAGE] coupled: the test asserts private repository call order. Pure refactoring breaks the test while behavior remains stable.
```
