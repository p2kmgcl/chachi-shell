# Lens: Pattern Reuse

Find the single strongest place where this PR hand-rolls something the codebase already provides — an existing helper, utility, abstraction, or convention it should be using instead. The goal is to simplify and normalize: less new code, more consistency with what's already there. One finding max, highest confidence only.

## Examples

`src/pipeline.py:L33: existing: hand-rolled chunk(list, n) helper. utils.batch() already does this. [P1]`

`api/auth.js:L20: convention: builds its own error-response dict. respondError() is used everywhere else in the codebase. [P2]`

## Process

1. Read the diff. Identify new code that solves a problem the codebase likely already solves.
2. Search the codebase for an existing helper, utility, abstraction, or convention that does the same job.
3. Confirm it is a genuine equivalent — same concern, drop-in or near-drop-in — not a superficial resemblance.
4. Pick the single best finding. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P1**: the hand-rolled version is buggy or diverges from the canonical one in a way that risks wrong behavior.
- **P2**: clear duplication of an existing, well-used utility — reuse removes real maintenance and drift risk.
- **P3**: the local version is fine; reuse is mild polish.

Do not inflate to P2 just to clear the suppression line.

## Boundaries

Return at most one finding — the strongest. The existing equivalent must actually exist and genuinely fit; a hypothetical "there might be a helper somewhere" does not qualify. If nothing clears the bar, return an empty list. That is the correct answer.
