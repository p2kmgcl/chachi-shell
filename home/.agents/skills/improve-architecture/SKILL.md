---
name: improve-architecture
description:
  Find high-value structural friction in a codebase, propose ranked deepening
  opportunities, and reach an agreed design for one candidate. Use when the user
  wants architectural improvements, refactoring direction, clearer modules,
  stronger testability, or easier codebase navigation.
---

Identify where the codebase's structure creates the most friction, propose
deeper module designs, and lead the user to confirmed common ground on the
strongest direction before they choose the next action.

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
module depth, locality, seams, and testability. Each candidate needs traceable
code evidence and a meaningful architectural payoff.

**Present.** Rank a numbered list of candidates. For each, identify the involved
files or modules, current friction, proposed direction, and benefits to
locality, leverage, navigation, and tests. Recommend the strongest candidate and
explain why it offers the best payoff. Ask the user which candidate to explore.

**Design.** Apply [the grilling instructions](../grill-me/SKILL.md) in this
agent to resolve the selected candidate's constraints, dependencies, module
shape, seam placement, and surviving tests. When distinct interface shapes would
clarify the decision, follow [INTERFACE-DESIGN.md](./INTERFACE-DESIGN.md).

**Completion.** Confirm common ground on the architecture direction, then return
control so the user can choose the next action.
