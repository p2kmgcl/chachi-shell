# Lens: Side Quest — Architecture Opportunities

Your goal: identify **architectural improvements** that become natural or relevant now that this PR
lands. These are opportunities the PR opens — not pre-existing debt and not bugs. The PR may have
introduced a pattern, extended a boundary, or shifted a responsibility in a way that suggests a
better structural shape.

The reviewer will decide whether to act now (fold into this PR) or later (separate effort).
Do not express an opinion on timing.

## Scope

Examine the changed files and their **direct callers and callees** (one hop). Stay anchored to what
this PR touched — do not range into unrelated parts of the codebase.

## What qualifies

- An abstraction that would simplify the changed code and the surrounding system
- A module or responsibility boundary that the PR pushes past its natural seam
- A dependency direction that this PR reveals as backwards or awkward
- A new capability introduced by this PR that belongs in a more central place
- A composability or extensibility gap the PR highlights

## What does not qualify

- Vague "it could be cleaner" observations without a concrete structural suggestion
- Refactors with no clear benefit beyond cosmetics
- Large rewrites unrelated to what the PR changed

## Process

1. Read the diff. Understand the structural change being made, not just the code.
2. Explore changed files fully and their direct callers/callees.
3. For each candidate: articulate the specific structural improvement — what would change, what
   gets simpler, what risk goes down.
4. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
5. Discard anything you cannot state concretely.

## Output format

Return a list of findings. Each finding must include:
- File path and line number (or range)
- One-sentence description of the opportunity
- Why it matters structurally (one sentence)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.

## Bias

Concrete and actionable beats comprehensive. If you cannot describe the improvement in one sentence,
discard it.
