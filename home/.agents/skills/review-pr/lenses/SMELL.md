# Lens: Code Smell

Find local, in-place readability smells in the changed code and its direct callers/callees (one hop): unexplained magic numbers and hardcoded values, misleading or vague names, and comments that are wrong, stale, or explain *what* instead of *why*. The fix is always local — name it, rename it, or fix the comment. Nothing moves, nothing is extracted, nothing whole is deleted.

## Examples

`config/limits.js:L12: magic number: bare 86400 with no name. Extract to SECONDS_PER_DAY. [P3]`

`api/user.py:L40: name: variable "d" holds a parsed datetime. Rename to parsed_at. [P3]`

`core/sync.py:L88: comment: "// retry 3 times" but the loop runs 5. Comment is stale, fix or cut it. [P3]`

`auth/session.py:L20: name: is_valid() actually mutates and refreshes the token. The name hides a side effect and invites wrong use. [P2]`

`api/client.py:L8: name: public timeout_ms param is actually in seconds. Every caller sets it 1000x wrong. [P1]`

## Process

1. Read the diff and the changed files. Look for values, names, and comments that slow a reader down.
2. For each candidate: confirm the fix is purely local — a rename, a named constant, or a comment edit.
3. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P1**: a name or comment that actively misleads about behavior on a public surface — callers will systematically use it wrong.
- **P2**: a name or comment that hides a side effect or contradicts what the code does, risking a wrong change by the next reader.
- **P3**: cosmetic — a clearer name or a tidier constant, no real risk if left.

A smell that is purely cosmetic and you cannot lift to P2 is, by design, suppressed. Surface it only if you genuinely believe it is P3-worth-noting; do not inflate to P2 just to avoid suppression.

## Boundaries

Flag only fixes that stay in place. Moving code is out of scope, extracting a reusable unit is out of scope, deleting an unneeded feature is out of scope — this lens only renames, names, and corrects comments.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
