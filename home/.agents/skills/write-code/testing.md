# Testing

Design small tests that shape simple code and preserve behavior that would
otherwise be difficult to understand or easy to break.

**Context.** Read the production behavior, public interface, existing tests,
helpers, and test commands. Before choosing tests, state a brief behavior map:
the required behavior, plausible regression, test boundary, and distinct
protection each proposed test provides. Note what will not be tested and why,
such as trusted dependency behavior, transparent wiring, or existing protection.

**Value.** Protect supported rules, effects, interactions, and contracts with
meaningful regression risk. Non-obvious behavior is a useful signal, not a
requirement: simple permission rules, compatibility guarantees, and documented
regressions can deserve protection. Observe the real result through the
smallest stable seam; do not assert internal steps. Do not add a generic
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
example, or another source independent of the implementation. Do not reproduce
the production algorithm or assert fixtures or mocks against themselves.
Assertions must observe the production result and detect the claimed regression.
Choose unit, integration, or UI scope by the smallest stable place that exposes
the real result. Avoid broad snapshots unless the complete output is the
behavior being protected.

**Retention.** A red test proves that it helped develop the change, not that it
deserves permanent maintenance. Keep a test when its supported behavior and
plausible regression risk justify its setup, runtime, coupling, and maintenance
cost. Combine equivalent protection and remove tests of transparent
implementation choices, direct wiring, or trusted dependency behavior unless
they protect an explicit supported contract. Similar tests at different
boundaries may catch different failures; broader coverage does not by itself
justify deleting narrower tests. Assess keep, rewrite, merge, or delete by each
test's distinct protection, not shared setup or assertion count. Preserve
distinct valuable scenarios and keep or rewrite uncertain deletion candidates.
A test may be deleted even when no remaining test would catch a deliberate
reversal of the changed line, provided no required contract is lost.

**Proof.** For new behavior, the initial red run proves the assertion is
load-bearing. For a retained test added or materially rewritten against existing
behavior, temporarily break the relevant production behavior or use an equivalent
failing-before check, observe the focused test fail, restore the production
code, and observe it pass. Never retain the temporary fault. Cleanup alone does
not require fault injection into unchanged tests or tests being deleted.

**Completion.** Run the focused tests and applicable repository checks. Finish
with the smallest justified suite: each retained test must provide distinct
protection, which may concern the same behavior at a different boundary. Do not
optimize for test count or coverage.
