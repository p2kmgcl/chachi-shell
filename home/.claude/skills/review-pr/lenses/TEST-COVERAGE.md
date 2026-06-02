# Lens: Test Coverage

Your goal: find **all meaningful gaps in test coverage** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A meaningful gap is a realistic edge case or failure mode introduced by this PR that has no test
and is likely to regress silently. Missing tests for obvious happy paths, pre-existing gaps, or
trivial code do not qualify.

## Process

1. Read the diff. Identify new logic paths: branches, error handlers, edge cases, state transitions.
2. Read the existing tests for changed files. Determine what's covered.
3. For each uncovered path: assess whether it is realistic and whether a regression would be caught
   by other means (types, runtime validation, integration tests).
4. Discard gaps that are low-risk or already implicitly covered.

## Output format

Return a list of findings. Each finding must include:
- File path and line number of the untested logic
- What scenario is missing (one sentence)
- Why a regression here would be hard to catch (one sentence)
- Priority label from `PRIORITIES.md`

If nothing meets the bar, return an empty list.

## Bias

Do not flag missing tests for trivial code or pre-existing gaps.
