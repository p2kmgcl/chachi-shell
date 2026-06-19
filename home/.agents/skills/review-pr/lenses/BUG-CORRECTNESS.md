# Lens: Correctness

Find all correctness issues introduced by this PR: wrong conditional, off-by-one, incorrect state transition, mishandled null/undefined, wrong operator, silent misbehavior on uncommon inputs. The code does not do what it is intended to do under specific, realistic conditions. When intent is ambiguous, return nothing.

This lens covers wrong-but-survivable results on edge and uncommon inputs — the code runs to completion and returns a subtly wrong answer. Crashes, data loss, and corruption are out of scope here.

## Examples

`utils/date.py:L22: off-by-one: range ends at n instead of n+1, last day of month excluded. Triggers on monthly reports. [P1]`

`api/search.js:L47: null: query.filters accessed before null check. Returns empty results silently when filters omitted. [P2]`

`billing/tax.py:L91: wrong operator: uses > instead of >= for tax bracket boundary. Edge-case inputs miscategorised. [P2]`

## Process

1. Read the diff. Understand what each change is supposed to do, then verify the implementation actually does it.
2. Explore the codebase: check types, contracts, invariants, and how the changed code is called with varying inputs.
3. For each candidate: confirm the behavior diverges from intent under a realistic (if uncommon) scenario, and confirm it is introduced by this PR.
4. Discard edge cases that require contrived inputs.

## Boundaries

If you find nothing that meets the bar, return an empty list. That is the correct answer.
