# Lens: Pattern Extraction

Find the single strongest pattern this PR introduces or repeats that is worth extracting into a reusable unit — duplicated logic, or a useful idiom applied inline in several places that would be clearer and safer as one named thing. One finding max, highest confidence only.

## Examples

`services/payment.py:L12,L44,L81: extract: retry logic duplicated across three call sites. Pull into with_retry(). [P2]`

`handlers/*.py: extract: same auth-check preamble copied into five handlers. Pull into a decorator. [P2]`

## Process

1. Read the diff. Identify repetition, or an idiom the PR applies inline more than once.
2. Confirm the pattern is genuinely reusable — it solves a recurring problem, not something specific to this one change.
3. Pick the single best finding. If two candidates are close, take the one with broader impact.
4. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P2**: the duplication is real and extraction removes meaningful repetition or prevents divergent bugs across copies.
- **P3**: minor repetition; extraction is optional polish.

Escalate to P2 when consolidating the copies prevents them drifting apart. Do not inflate to P2 just to clear the suppression line.

## Boundaries

Return at most one finding — the strongest. The pattern must be genuinely reusable, not a one-off. If nothing clears the bar, return an empty list. That is the correct answer.
