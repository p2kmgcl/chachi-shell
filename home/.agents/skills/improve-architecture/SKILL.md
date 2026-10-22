---
name: improve-architecture
description:
  Find high-value structural friction in code or test suites, propose ranked
  improvements, and reach an agreed design for one candidate. Use when the user
  wants architectural improvements, refactoring direction, clearer modules,
  stronger testability, test-suite cleanup, or easier codebase navigation.
---

Identify where code or test structure creates the most friction, propose
deeper modules or simpler test structures, and lead the user to confirmed common
ground on the strongest direction before they choose the next action.

**Context.** Read the shared [agent-state conventions](../../AGENT-STATE.md),
relevant handoffs, and established codebase documentation. Explore the code to
understand its current behavior and structure.

**Scope.** Follow an area, module, or pain point named by the user. Otherwise,
inspect enough commit history to find recurring hotspots, prioritizing changes
from the current Git identity and identifiable team authors. Use the
repository's full history when that narrower history provides no useful signal.

**Explore.** Apply the vocabulary in [LANGUAGE.md](./LANGUAGE.md) and the
deepening guidance in [DEEPENING.md](./DEEPENING.md). Use available subagents to
inspect the scoped code organically and find concrete friction in comprehension,
module depth, locality, seams, and testability. Inspect tests for internal
mocking, duplicated protection, brittle fixtures, and coupling that makes
behavior-preserving refactors expensive. Apply the shared
[testing guidance](../write-code/testing.md) to judge test value and retention.
Allow test-structure improvements without requiring a production redesign. Each
candidate needs traceable code evidence and a meaningful structural payoff.

**Present.** Rank a numbered list of candidates. For each, identify the involved
files or modules, current friction, proposed direction, and benefits to
locality, leverage, navigation, and tests. Recommend the strongest candidate and
explain why it offers the best payoff. Ask the user which candidate to explore.

**Design.** Apply [the grilling instructions](../grill-me/SKILL.md) in this
agent to resolve the selected candidate's constraints, dependencies, module
shape, and seam placement. For affected tests, propose keep, rewrite, merge, or
delete with the distinct protection retained, any protection lost, and necessary
replacement tests. Keep uncertain deletion candidates or propose rewriting them.
When distinct interface shapes would clarify the decision, follow
[INTERFACE-DESIGN.md](./INTERFACE-DESIGN.md).

**Completion.** Confirm common ground on the architecture direction, then return
control so the user can choose the next action.
