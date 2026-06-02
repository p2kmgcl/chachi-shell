# Lens: Test Coverage

Your goal: find **all meaningful test quality problems** introduced by this PR — missing coverage, bad tests, and over-testing. You may return zero findings. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

Reference `~/.agents/skills/tdd/tests.md` and `~/.agents/skills/tdd/mocking.md` for what constitutes good vs bad tests.

## Process

1. Read the diff. Identify new logic paths: branches, error handlers, edge cases, state transitions.
2. Read the existing and new tests for changed files.
3. For each finding category below, assess the diff against the criteria.
4. Discard findings that are low-risk, pre-existing, or already implicitly covered.

## Finding Categories

### 1. Missing coverage

A meaningful gap is a realistic edge case or failure mode introduced by this PR that has no test and is likely to regress silently. Missing tests for obvious happy paths, pre-existing gaps, or trivial code do not qualify.

For each uncovered path: assess whether it is realistic and whether a regression would be caught by other means (types, runtime validation, integration tests).

### 2. Bad tests

Tests that are present but undermine confidence or couple to implementation:

- Mocking internal collaborators (classes/modules the codebase owns) — mock at system boundaries only
- Testing private methods or internal state directly
- Asserting on call counts, call order, or internal wiring
- Bypassing the public interface to verify (e.g. querying the DB directly instead of using the retrieval API)
- Test names or assertions that describe HOW the code works, not WHAT behavior it provides
- Tests that would break on a pure internal refactor where observable behavior is unchanged

### 3. Over-testing

Tests that exist but add noise without protecting real behavior:

- Testing obvious happy paths that carry no meaningful regression risk
- Duplicate tests that cover the same logical path under different names
- Tests written in bulk for imagined behavior not yet driven by real implementation (horizontal-slice anti-pattern)
- Tests so tightly scoped they test data structures or function signatures rather than user-facing outcomes

## Output format

Return findings grouped into three sections: **Missing coverage**, **Bad tests**, **Over-testing**. Each finding must include:

- File path and line number of the relevant test or untested logic
- What the problem is (one sentence)
- Why it matters — regression risk for missing coverage, false confidence or maintenance burden for bad/over tests (one sentence)
- Priority label from `PRIORITIES.md`

If a section has no findings, omit it.
