# Testing

Design small tests that shape simple code and preserve behavior that would
otherwise be difficult to understand or easy to break.

**Context.** Read the production behavior, public interface, existing tests,
helpers, and test commands. Before choosing tests, state a brief behavior map:
the required behavior, the result that matters, and the distinct fact each
proposed test will preserve.

**Value.** Test custom rules, effects, and interactions that are not obvious
from the tested code's name or public interface. Observe the real result through
the smallest stable seam; do not assert internal steps. Do not add a generic
render, presence, or control-works test unless that fact is itself supported
behavior needing protection. Avoid tests that restate transparent wiring, such
as a feature flag directly showing or hiding a component. Treat the gate as
setup unless it implements non-obvious policy, combines multiple conditions,
causes side effects, or protects an explicit rollout contract.

**TDD.** For new behavior, write the smallest test first and confirm it fails
for the missing behavior. Let that test shape the production interface. If one
small behavior needs long preparation, custom mock systems, or unrelated
objects, choose a simpler code shape before implementing it. Treat the test as
development scaffolding until the retention review; reaching red and green does
not make it part of the durable suite.

**Setup.** The number of mocks does not by itself prove that production code is
too complex: simple substitutes for existing APIs may be acceptable. Their
setup, coupling, and maintenance still count against the value of retaining the
test. When preparation is large relative to the protected behavior, prefer a
simpler seam or remove the test after it has served the TDD cycle.

**Expectations.** Derive expected results from the requirement, a worked
example, or another source independent of the implementation. Choose unit,
integration, or UI scope by the smallest stable place that exposes the real
result. Avoid broad snapshots unless the complete output is the behavior being
protected.

**Retention.** A red test proves that it helped develop the change, not that it
deserves permanent maintenance. Keep it only when it protects important
supported behavior involving a non-obvious rule, transformation, interaction,
failure mode, or state transition with plausible regression risk. Its stable
regression value must justify its setup, runtime, coupling, and maintenance
cost. Combine overlapping protection and remove tests of transparent
implementation choices, direct wiring, or trusted dependency behavior. A test
may be deleted even when no remaining test would catch a deliberate reversal
of the changed line.

**Proof.** For new behavior, the initial red run proves the assertion is
load-bearing. For existing behavior, temporarily break the relevant production
behavior or use an equivalent failing-before check, observe the focused test
fail, restore the production code, and observe it pass. Never retain the
temporary fault.

**Completion.** Run the focused tests and applicable repository checks. Finish
with the smallest set in which every test protects a different supported fact;
do not optimize for test count or coverage.
