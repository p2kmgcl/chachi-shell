# Lens: Over engineering

Code review focused exclusively on over-engineering: complexity that isn't needed, whether this PR added it or merely touched it. Finds what to delete: reinvented standard library, unneeded dependencies, speculative abstractions, dead flexibility. One line per finding: location, what to cut, what replaces it. Hunts complexity only — nothing else.

## Scope

Review the changed files and their direct callers/callees (one hop) for unnecessary complexity. One line per finding: location, what to cut, what replaces it.

## Examples

`src/email.py:L12-38: stdlib: 27-line validator class. "@" in email, 1 line, real validation is the confirmation mail. [P2]`

`utils.js:L4: native: moment.js imported for one format call. Intl.DateTimeFormat, 0 deps. [P1]`

`repo.py:L88: yagni: AbstractRepository with one implementation. Inline it until a second one exists. [P3]`

`L52-71: delete: retry wrapper around an idempotent local call. Nothing replaces it. [P2]`

`L30-44: shrink: manual loop builds dict. dict(zip(keys, values)), 1 line. [P3]`

## Scoring

End with the only metric that matters: `net: -<N> lines possible.`

If there is nothing to cut, say `Lean already. Ship.` and stop.

## Priority

- **P1**: actively blocks future changes, or a dependency that can be fully deleted
- **P2**: clear over-engineering with meaningful savings
- **P3**: marginal savings, only if you're very confident it's not needed

P3 is the floor — if confidence doesn't reach P3, return an empty list.

## Boundaries

Complexity only. A single smoke test or `assert`-based self-check is acceptable — treat it as passing the bar. Lists findings only, without applying fixes.

## Tags

- `delete:` dead code, unused flexibility, speculative feature. Replacement: nothing.
- `stdlib:` hand-rolled thing the standard library ships. Name the function.
- `native:` dependency or code doing what the platform already does. Name the feature.
- `yagni:` abstraction with one implementation, config nobody sets, layer with one caller.
- `shrink:` same logic, fewer lines. Show the shorter form.
