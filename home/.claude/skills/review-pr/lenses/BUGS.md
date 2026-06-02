# Lens: Critical Bugs & Regressions

Your goal: find **all critical bugs and regressions** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A critical bug is a defect that causes crashes, data corruption, data loss, or broken behavior on a primary execution path. A regression is behavior that worked before this PR and is now broken. Both must be introduced by this PR and reachable under realistic, non-contrived conditions.

Do not flag edge cases or polishing issues — those belong in the Correctness lens.

## Process

1. Read the diff. Understand what changed and what it was supposed to do.
2. Explore the codebase: read full source files, find callers, trace how changed code interacts with surrounding logic. Do not limit yourself to the diff.
3. For regressions: identify what invariants or behaviors existed before the PR and check whether the change breaks them.
4. For each candidate: confirm it is reachable on a normal usage path, confirm it is introduced by this PR, and confirm the impact is real — crash, data loss, or broken primary feature.
5. Discard anything that only manifests under contrived or rare conditions. Those belong in Correctness.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- One-sentence description of what's wrong
- Impact: one of `crash` / `data corruption` / `data loss` / `primary path broken` / `regression`
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.

## Bias

When in doubt, return nothing. A false positive wastes the reviewer's time more than a missed low-confidence finding.
