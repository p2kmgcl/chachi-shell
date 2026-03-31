---
description: Documentation standards to follow when creating or updating component docs in any project
user-invocable: true
---

- Check if the project has a doc generator or scaffold tool before writing from scratch.
- Update existing docs when you add, rename, or remove props or public API surface. Keep
  examples, descriptions, and API tables in sync with the current implementation.
- Link to related docs instead of duplicating information. Treat docs as interconnected
  wiki articles, not isolated pages.
- Reuse existing mocks, fixtures, and API helpers from the codebase. If new ones are needed,
  create them in the canonical location (next to the API definition or in shared fixtures),
  not inline in the docs.
- Be brief. Good names and types are the primary documentation. Only document what cannot
  be inferred from the API itself — intent, constraints, and gotchas.
- Do not describe behavior that is obvious from the example. Let examples speak for
  themselves.
- Show the simplest useful example first. Add separate sections only for edge cases and
  features that differ enough to warrant their own explanation.
- Give every code example a titled heading so it is linkable and scannable.
- Every code example must be self-contained and runnable — import everything it needs.
- Prefer interactive examples over static props tables when the docs framework supports it.
- Document only the public API that consumers interact with directly. Skip internals.
- Mock or stub any external dependencies so examples work without a running backend.
