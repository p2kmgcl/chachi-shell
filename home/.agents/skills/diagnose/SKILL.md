---
name: diagnose
description:
  Find the evidenced cause of a bug, performance regression, or other
  unexpected software behavior. Use when the user reports an issue they do not
  understand, asks why it happens, or asks to debug or diagnose it.
---

Find and explain why the reported behavior occurs, collaborating with the user
when only they can operate the affected application.

**Context.** Read the repository instructions, relevant code and tests, and
available evidence. Establish the observed and expected behavior; ask only for
missing details that materially change where investigation should begin.

**Investigate.** Use the simplest useful method to pursue the cause: inspect
code, state, and history; run focused checks; reproduce or compare behavior;
add instrumentation; or use a debugger, browser tools, traces, and profilers.
Follow evidence instead of imposing a fixed plan, and distinguish the reported
issue from nearby failures.

**Collaborate.** Operate the available code, tools, and application directly.
When only the user can reproduce live behavior, prepare focused diagnostics,
give them an exact action to perform, and state what output or observation to
return. Interpret the result and continue with the next useful probe.

**Instrument.** Add any reversible, narrowly scoped diagnostic aid that makes
the cause easier to observe, including logs, assertions, breakpoints, harnesses,
and performance measurements. Tag or otherwise track every temporary change,
preserve unrelated work, and remove the diagnostic changes when they are no
longer needed.

**Evidence.** Continue until the evidence explains the causal mechanism and the
conditions that trigger it. When the available environment cannot establish the
cause, report what the evidence supports, what has been ruled out, the exact
missing access or artifact, and the most useful next probe. Never present a
plausible theory as a demonstrated cause.

**Completion.** Finish when the cause is identified and explained, not merely
when the symptom disappears. Remove temporary diagnostic artifacts unless the
user asks to retain them, then report the cause, its supporting evidence,
triggering conditions, and any remaining uncertainty.
