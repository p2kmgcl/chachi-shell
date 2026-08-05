---
name: write-code
description:
  Implement code as approved test-driven vertical slices with atomic commits.
  Use when the user asks to build a feature, fix an understood bug, refactor
  code, or otherwise implement or modify production code.
---

Implement the requested code as user-approved vertical slices, keeping each
slice test-driven, independently green, and recorded as one atomic commit.

**Context.** Read the repository instructions, supplied specification or ticket,
relevant code and tests, and recent commit conventions. Identify the project's
focused and full verification commands. Preserve unrelated existing changes and
record the starting revision for the final comparison.

**Plan.** Before editing, propose an ordered list of vertical slices and wait for
approval. For each slice, state the complete observable behavior it delivers,
the seam and behavior to test, its focused verification, and its atomic commit
outcome. Keep every slice narrow but end-to-end across the layers it needs. Put
enabling refactors first; sequence unavoidable wide migrations as expand,
migrate in independently green batches, then contract.

**Execute.** After approval, complete every slice in order without pausing while
the plan remains valid:

1. **Red.** Write one test through the approved seam and run it. Confirm it fails
   for the missing behavior, not because the harness is broken.
2. **Green.** Implement only enough production code to pass that test, then run
   the focused test again. Add the next test only after the current cycle is
   green.
3. **Refactor.** Improve the green implementation without changing behavior,
   using [the refactoring prompts](./refactoring.md) only where the slice
   provides evidence for them. Keep the focused tests green after each change.
4. **Verify.** Run the slice's focused tests and applicable static checks.
5. **Commit.** Apply the [commit skill](../commit/SKILL.md) to record only this
   independently coherent, passing slice.

**Refactors.** For a behavior-preserving refactor, establish that an existing
test exercises the approved seam and passes before editing; then refactor in
independently green increments instead of manufacturing a failing test.

**Tests.** Write the smallest set that specifies observable behavior through
public interfaces. Derive expected results independently from the
implementation. Prefer unit or integration tests; use synthetic or end-to-end
tests only when the user asks or the behavior has no cheaper trustworthy seam.
Read [test examples](./tests.md) when choosing assertions and
[mocking guidance](./mocking.md) when a system boundary requires a substitute.

**Design.** Let code explain itself through precise names, focused functions,
and types; comment only information the code cannot express. Default symbols to
unexported and colocate private helpers with their sole caller. Organize files
by domain or feature. Give each React component its own file. When changing an
interface or struggling to find a trustworthy test seam, apply
[deep-module design](./deep-modules.md) and
[interface-design guidance](./interface-design.md).

**Mechanics.** Use the project's generator for new modules, components, or
packages after checking its current help or authoritative documentation. Add
dependencies through the package manager so manifests and lockfiles remain in
sync. When the active repository is Web UI, apply its optional
[toolchain and dependency rules](./web-ui.md).

**Deviation.** An expected red test is part of the workflow. Stop for human
direction when evidence instead invalidates an approved slice, requires a new
slice or seam, exposes conflicting requirements, leaves verification unable to
reach green, or reveals another unplanned issue. Investigate only far enough to
report the evidence and the decision needed; do not revise the plan or fix the
new issue without approval.

**Completion.** After every approved slice is committed, run the full relevant
test suite and applicable lint, typecheck, and build checks. Report completion
only when they pass and the approved behavior is implemented. Otherwise report
the exact incomplete state and wait for direction. Do not invoke review,
publish, or deployment workflows; the user chooses the next action.
