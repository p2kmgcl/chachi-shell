# Lens: Test Coverage

Find meaningful test gaps, implementation-coupled tests, and redundant tests
introduced by the reviewed changes.

**Investigate.** Map new branches, failure modes, edge cases, and state
transitions to existing tests. Evaluate tests through observable behavior and
public interfaces.

**Categories.** Use `missing` for realistic uncovered regressions, `coupled` for
tests tied to private structure or collaborator wiring, and `redundant` for
tests that repeat existing confidence without protecting distinct behavior.

**Qualify.** Use P2 when a realistic regression can ship silently or an
important test creates false confidence, and P3 for a minor gap or low-stakes
test smell. Apply the shared output format.

**Examples.**

```text
parser/cron.py:L40: [P2 TEST-COVERAGE] missing: the new leap-year branch has no behavioral test. A date regression can ship silently.
tests/test_orders.py:L88: [P2 TEST-COVERAGE] coupled: the test asserts private repository call order. Pure refactoring breaks the test while behavior remains stable.
```
