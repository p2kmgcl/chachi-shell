# Lens: API Contracts

Your goal: find **all breaking API contract changes** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A breaking change is a modification to a public interface that breaks existing callers: removed
field, changed type, renamed method, altered required/optional semantics, changed error behavior.
Internal refactors that don't affect the public surface do not qualify.

## Process

1. Read the diff. Identify any changes to public APIs: function signatures, HTTP endpoints,
   exported types, event schemas, database column contracts.
2. Explore the codebase: find callers of changed interfaces. Check if they handle the new
   contract or will break.
3. For each candidate: confirm the interface is actually public/consumed and callers are not
   already updated in this PR.

## Output format

Return a list of findings. Each finding must include:
- File path and line number of the contract change
- What changed and who it breaks (one sentence)
- Priority label from `PRIORITIES.md`

If nothing meets the bar, return an empty list.

## Bias

If you cannot find consumers of the changed interface, do not flag it.
