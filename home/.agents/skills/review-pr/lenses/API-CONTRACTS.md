# Lens: API Contracts

Find all breaking API contract changes introduced by this PR. A breaking change modifies a public interface in a way that breaks existing callers: removed field, changed type, renamed method, altered required/optional semantics, changed error behavior. Flag only changes to public interfaces with identifiable consumers.

## Examples

`api/users.py:L14: removed: field "email" dropped from UserResponse. All callers expecting it will break. [P0]`

`routes/orders.js:L88: type change: orderId changed from int to string. Callers doing arithmetic on it will silently misbehave. [P1]`

`lib/auth.py:L32: semantics: token param changed from optional to required. Unauthenticated callers will now 500 instead of 401. [P1]`

## Process

1. Read the diff. Identify changes to public APIs: function signatures, HTTP endpoints, exported types, event schemas, database column contracts.
2. Find callers of changed interfaces in the codebase. Check if they handle the new contract or will break.
3. Confirm the interface is actually public/consumed and callers are not already updated in this PR.
4. Apply the priority rubric from `PRIORITIES.md`.

## Boundaries

Flag only interfaces with identifiable consumers. Return only findings you are genuinely confident about.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
