# Lens: Over-Engineering

Find complexity introduced or made actionable by the reviewed changes that can
be replaced with a smaller standard, native, or direct implementation.

**Investigate.** Review changed files and their direct callers and callees for
speculative abstractions, redundant dependencies, dead flexibility, and manual
implementations of existing platform features.

**Qualify.** State the exact code to simplify and its concrete replacement. Use
P1 when the complexity actively blocks changes or enables full dependency
removal, P2 for meaningful simplification, and P3 for confident marginal
savings. Apply the shared output format.

**Categories.** Use `delete` for removable code, `stdlib` or `native` for an
existing replacement, `yagni` for unused flexibility, and `shrink` for an
equivalent smaller implementation.

**Examples.**

```text
utils.js:L4: [P1 OVER-ENGINEERING] native: a dependency supports one date-format call. Intl.DateTimeFormat provides the same behavior and removes the dependency.
repo.py:L88: [P3 OVER-ENGINEERING] yagni: AbstractRepository has one implementation and one caller. The concrete repository provides the same interface directly.
```
