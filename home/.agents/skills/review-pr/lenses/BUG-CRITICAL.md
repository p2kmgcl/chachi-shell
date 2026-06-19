# Lens: Critical Bugs & Regressions

Find all critical bugs and regressions introduced by this PR. A critical bug causes crashes, data corruption, data loss, or broken behavior on a primary execution path. A regression is behavior that worked before and is now broken. Both must be introduced by this PR and reachable under realistic conditions. When in doubt, return nothing — a false positive wastes more time than a missed low-confidence finding.

## Examples

`orders/checkout.py:L44: crash: division by zero when cart is empty. Primary checkout path. [P0]`

`auth/session.js:L12: regression: logout no longer invalidates the server-side token. Was working before this PR. [P0]`

`billing/invoice.py:L78: data loss: invoice lines silently dropped when total exceeds limit instead of raising. [P0]`

## Process

1. Read the diff. Understand what changed and what it was supposed to do.
2. Explore the codebase: read full source files, find callers, trace how changed code interacts with surrounding logic.
3. For regressions: identify what invariants or behaviors existed before the PR and check whether the change breaks them.
4. For each candidate: confirm it is reachable on a normal usage path, confirm it is introduced by this PR, and confirm the impact is real.
5. Discard anything that only manifests under contrived or rare conditions.

## Boundaries

Flag only issues that break a primary execution path under realistic conditions.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
