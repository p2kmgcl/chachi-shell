# Lens: Side Quest — Pattern Generalization

Your goal: identify **patterns introduced or reinforced by this PR** that should be applied
consistently across the codebase but currently are not. This PR may have done something well —
a useful abstraction, a safer idiom, a clearer naming convention — that exists elsewhere in
inconsistent or weaker form.

The reviewer will decide whether to generalize now (fold into this PR) or later (separate effort).
Do not express an opinion on timing.

## Scope

Start with the changed files to identify the pattern. Then look outward — scan the codebase
broadly enough to spot where the pattern is absent or inconsistently applied. This lens has wider
lateral scope than other lenses precisely because inconsistency lives elsewhere.

## What qualifies

- An idiom used in this PR that solves a problem also present in other files, but solved worse there
- A naming convention or structural convention this PR establishes or improves that is applied
  inconsistently across the codebase
- A safety or correctness pattern (null handling, error propagation, type narrowing) that this PR
  gets right but that is missing in analogous code

## What does not qualify

- Patterns that only make sense in the context of this specific change
- Style preferences or formatting conventions
- Hypothetical patterns the PR doesn't actually use

## Process

1. Read the diff. Identify the strongest patterns — things done deliberately and well.
2. For each pattern: search the codebase for analogous code where the pattern is absent or weaker.
3. For each site: confirm it is a genuine analog (same concern, not superficially similar).
4. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
5. Discard marginal similarities.

## Output format

Return a list of findings. Each finding must include:
- File path and line number of the **inconsistent site** (not the PR itself)
- One-sentence description of the pattern and where it's missing
- Why consistency matters here (one sentence)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.

## Bias

Only flag gaps where the inconsistency has real consequences — correctness, safety, or
maintainability. Do not flag cosmetic inconsistency.
