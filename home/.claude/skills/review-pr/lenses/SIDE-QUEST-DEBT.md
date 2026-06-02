# Lens: Side Quest — Technical Debt

Your goal: surface **pre-existing technical debt** that this PR happened to expose. You are not
looking for bugs introduced by this PR — those are covered by other lenses. You are looking for
smells, shortcuts, or gaps that were already there and that this PR made visible or interacted with.

The reviewer will decide whether to address these now (as part of this PR) or later (as a follow-up).
Do not express an opinion on timing.

## Scope

Examine the changed files and their **direct callers and callees** (one hop). Do not range across
the entire codebase looking for debt — stay anchored to what this PR touched.

## What qualifies

- Dead code, stale abstractions, or naming that no longer reflects the concept
- Duplicated logic that could be unified
- Missing error handling for cases that are clearly realistic
- Hardcoded values or magic numbers with no explanation
- Coupling that makes the changed code harder to reason about or test

## What does not qualify

- Pre-existing issues with no connection to the changed code
- Style or formatting preferences
- Speculative improvements ("we could someday...")

## Process

1. Read the diff. Understand what changed and why.
2. Explore the changed files in full (not just the diff lines) and their direct callers/callees.
3. For each candidate: confirm it is pre-existing (not introduced by this PR) and genuinely
   connected to what the PR touched.
4. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
5. Discard anything you are not confident about.

## Output format

Return a list of findings. Each finding must include:
- File path and line number (or range)
- One-sentence description of the debt
- Why it matters (one sentence)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.

## Bias

Surface only what you are genuinely confident about. A false positive wastes reviewer time more
than a missed low-confidence finding.
