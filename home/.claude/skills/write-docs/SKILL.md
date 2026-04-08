---
description: Documentation standards to follow when creating or updating component docs in any project
user-invocable: true
---

Scope: changes in the current branch — committed, staged, or unstaged.

- Invoke `local-rules` skill.
- Check if the project has a doc generator or scaffold tool before writing from scratch.
- Update existing docs when branch changes add, rename, or remove public API surface. Keep
  examples, descriptions, and API tables in sync with the current implementation.
- Link to related docs instead of duplicating. Treat docs as interconnected wiki articles.
- Reuse existing mocks, fixtures, and API helpers. Create new ones in their canonical
  location, not inline in the docs.
- Be brief. Only document what cannot be inferred from the API — intent, constraints,
  gotchas. Let examples speak for themselves.
- Show the simplest useful example first. Add separate sections only for meaningfully
  different edge cases.
- Every code example must be self-contained, runnable, and have a titled heading.
- Prefer interactive examples over static props tables when the framework supports it.
- Document only public API. Skip internals.
- Mock or stub external dependencies so examples work without a running backend.
