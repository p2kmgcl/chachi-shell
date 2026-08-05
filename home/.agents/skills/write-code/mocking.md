# Mocking

Substitute dependencies only at system boundaries:

- External APIs
- Time and randomness
- File systems
- Databases when a representative test database is impractical

**Owned code.** Do not mock owned classes, modules, or internal collaborators.
Exercise them together through the approved public seam so refactoring internals
does not break the test.

**Adapters.** At a system boundary, inject a narrow operation-specific adapter.
Prefer `getUser(id)` or `charge(order)` over a generic request function whose
fake must reimplement routing logic. Each substitute should return one explicit
shape and contain no conditional behavior unrelated to the test.
