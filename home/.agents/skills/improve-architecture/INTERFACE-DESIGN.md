# Interface Design

Explore materially different interfaces for one deepening candidate, then
compare their leverage, locality, seam placement, and fit before recommending a
direction.

**Frame.** Explain the constraints, dependency categories from
[DEEPENING.md](./DEEPENING.md), and behavior the interface must support. Include
a small illustrative sketch when it makes the constraints concrete.

**Explore.** Launch at least three parallel subagents with independent briefs
grounded in the relevant code and [LANGUAGE.md](./LANGUAGE.md). Give each a
distinct design priority: the smallest useful interface, broad flexibility, or
the simplest path for the common caller. Add a ports-and-adapters variant when a
remote seam materially shapes the design.

**Output.** Have each subagent provide:

1. The interface, including invariants, ordering, and error modes.
2. A representative caller example.
3. The behavior hidden behind the seam.
4. Its dependency and adapter strategy.
5. Its strongest leverage and principal trade-off.

**Compare.** Present each design clearly, compare them in prose, and recommend
the strongest option or a coherent hybrid.
