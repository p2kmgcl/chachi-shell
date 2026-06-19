# Lens: Test Coverage

Find all meaningful test quality problems introduced by this PR — missing coverage, bad tests, and over-testing. A meaningful finding is a realistic edge case left untested and likely to regress silently, a test that couples to implementation and undermines confidence, or a test that adds noise without protecting real behavior. Return only findings you are genuinely confident about. Reference `~/.agents/skills/tdd/tests.md` and `~/.agents/skills/tdd/mocking.md` for what constitutes good vs bad tests.

## Examples

`parser/cron.py:L40: missing: leap-year branch added in this PR has no test. Silent regression risk. [P2]`

`tests/test_orders.py:L88: bad test: mocks the internal OrderRepository. Breaks on any refactor, verifies nothing real. [P2]`

`tests/test_utils.py:L12: over-testing: asserts the exact call count of a private helper. Tests how, not what. [P3]`

## Process

1. Read the diff. Identify new logic paths: branches, error handlers, edge cases, state transitions.
2. Read the existing and new tests for changed files.
3. Assess each path against the three categories below.
4. Apply the priority rubric from `PRIORITIES.md`.

## Categories

- **Missing coverage**: a realistic edge case or failure mode introduced by this PR with no test, likely to regress silently and not caught by types, runtime validation, or integration tests.
- **Bad tests**: mocking internal collaborators, testing private methods or internal state, asserting on call counts/order/wiring, bypassing the public interface, or names/assertions that describe HOW rather than WHAT — tests that would break on a pure internal refactor.
- **Over-testing**: obvious happy paths with no regression risk, duplicate tests of the same path, tests for imagined behavior not yet driven by real implementation, or tests scoped so tightly they verify data structures rather than user-facing outcomes.

## Priority

- **P2**: an untested realistic failure mode likely to regress silently, or a bad test giving false confidence on important logic.
- **P3**: a minor gap or a low-stakes test smell.

Escalate to P2 when the gap or bad test would let a real regression ship unnoticed. Do not inflate to P2 just to clear the suppression line.

## Boundaries

Flag only findings that are realistic, introduced by this PR, and not already implicitly covered. Group findings by category. Omit a category that has no findings.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
