# Deepening Modules

Deepen a cluster of shallow modules by concentrating behavior behind a smaller
interface and placing each dependency at a seam that supports realistic tests.
Use the vocabulary in [LANGUAGE.md](./LANGUAGE.md).

**In-process dependencies.** Merge pure computation and in-memory state behind
the deepened interface, then test that interface directly.

**Local substitutes.** Keep dependencies such as an in-memory filesystem or
embedded database behind an internal seam and run the substitute in the test
suite.

**Owned remote dependencies.** Define a port at the network seam. Place an HTTP,
RPC, or queue adapter in production and an in-memory adapter in tests while the
deep module owns the behavior.

**External dependencies.** Inject a port for third-party systems and use a
purpose-built test adapter to exercise the deep module's behavior.

**Seam discipline.** Give each seam concrete variation, commonly production and
test adapters. Keep seams used only by the implementation inside the module so
the external interface remains small.

**Testing.** Exercise observable outcomes through the deepened module's
interface. Apply the shared [testing guidance](../write-code/testing.md) for
retention: replace shallow-module tests when interface-level tests preserve
their required protection, rather than retaining both by default. Broader tests
do not automatically supersede narrower ones; retain distinct protection against
different failures or contracts. Keep tests independent of internal refactors.
