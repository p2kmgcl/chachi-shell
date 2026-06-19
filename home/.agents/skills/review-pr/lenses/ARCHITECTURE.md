# Lens: Architecture Opportunities

Identify code that belongs somewhere else: moved to a more appropriate layer or module, grouped with related code it's currently separated from, or split apart when one unit is doing too much. Also dependency directions this PR reveals as backwards. Stay anchored to what this PR touched and its direct callers/callees (one hop).

## Examples

`payments/gateway.py:L55: move: PaymentGateway handles retry logic that belongs in the HTTP client layer. Move it down, all callers benefit. [P2]`

`auth/middleware.js:L20: direction: UserService depends on SessionStore, but SessionStore shouldn't know about users. Invert the dependency. [P1]`

`core/handler.py:L88: split: one function parses, validates, and persists. Split into three so each is testable alone. [P2]`

## Process

1. Read the diff. Understand the structural change being made, not just the code.
2. Explore changed files and their direct callers/callees.
3. For each candidate: articulate the specific relocation, regrouping, split, or inversion — what moves where, and what gets simpler or safer as a result.
4. Apply the priority rubric from `PRIORITIES.md`.
5. Discard anything you cannot state concretely in one sentence.

## Priority

- **P1**: the current shape will actively block an imminent or in-progress change.
- **P2**: the shape adds real friction or risk that the move, split, or inversion would remove.
- **P3**: marginal tidiness with no concrete payoff.

Do not inflate to P2 just to clear the suppression line.

## Boundaries

Flag only concrete relocation, grouping, splitting, or dependency-direction changes with clear benefit, directly connected to what the PR changed.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
