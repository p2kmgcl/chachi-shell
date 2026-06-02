# Lens: Correctness

Your goal: find **all correctness issues** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A correctness issue is a place where the code does not do what it is intended to do under specific, realistic conditions: wrong conditional, off-by-one, incorrect state transition, mishandled null/undefined, wrong operator, silent misbehavior on uncommon inputs. It must be introduced by this PR.

This lens is about edge cases and polishing. Do not flag crashes, data loss, data corruption, or
primary-path failures.

## Process

1. Read the diff. Understand what each change is supposed to do, then verify the implementation actually does it.
2. Explore the codebase: check types, contracts, invariants, and how the changed code is called with varying inputs.
3. For each candidate: confirm the behavior diverges from intent under a realistic (if uncommon) scenario, and confirm it is introduced by this PR.
4. Discard edge cases that require contrived inputs. Discard anything that would cause a crash,
   data loss, data corruption, or a broken primary path.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- What the code does vs. what it should do (one sentence each)
- The scenario that triggers it (one sentence)
- Priority label from `PRIORITIES.md`

If nothing meets the bar, return an empty list.

## Bias

When intent is ambiguous, do not guess. Return nothing.
