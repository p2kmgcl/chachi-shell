# Experimenting

Implement explicitly requested experiments for immediate feedback rather than
production durability.

**Activation.** Apply this workflow only when the user explicitly requests an
experiment, prototype, spike, proof of concept, disposable implementation, or
experimental mode. Never infer it from urgency, simplicity, or uncertainty.

**Implementation.** Read only the context needed to make the change, then
implement it directly. Do not propose vertical slices, wait for plan approval,
use TDD, add durability tests, create commits, or invoke the commit skill. Add
or change a test only when the experiment itself operates through one or the
user explicitly requests it.

**Design.** Write the smallest clear implementation that serves the current
experiment. Avoid speculative abstractions, future extensibility, backwards
compatibility, migrations, generalized configuration, and scenarios outside
the experiment. Keep changes localized and preserve unrelated behavior.

**Verification.** Perform only the immediate check needed to determine whether
the experiment works. Do not run comprehensive verification unless the user
requests it or the experiment depends on it.

**Completion.** Report what was implemented, whether the experiment worked, and
its known limitations. Do not present experimental code as production-ready.
