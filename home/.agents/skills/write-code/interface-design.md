# Interface Design for Testability

Place a seam where behavior varies, and let callers and tests use the same
interface.

1. Accept external dependencies instead of constructing them inside the
   behavior under test.
2. Return observable results where practical instead of hiding outcomes in side
   effects.
3. Keep the public surface small: fewer methods, parameters, invariants, and
   error modes mean less setup for every caller and test.
4. Introduce an abstraction for actual variation, not a hypothetical future
   implementation.

**Visibility.** Keep test-only seams private to the module. Do not expand the
public interface only so tests can reach implementation details.
