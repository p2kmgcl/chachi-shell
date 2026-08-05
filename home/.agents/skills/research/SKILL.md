---
name: research
description:
  Resolve a bounded local or external knowledge gap so a larger task or
  decision can continue. Use when asked to research a topic, verify facts,
  gather documentation or API information, understand unfamiliar code in its
  wider system context, or perform a focused investigation for another
  workflow.
---

Resolve one bounded knowledge gap so the caller can confidently continue its
larger task or decision.

**Question.** Derive a focused question from the request and relevant context.
Narrow a broad request when one interpretation is safe; ask only when the
choice would materially change the research.

**Investigation.** Inspect local or external information as the question
requires. Choose sources and methods from context. For unfamiliar code, trace
the relevant modules and callers far enough to explain their place in the
larger system using the project's domain vocabulary. Remain read-only; do not
modify code, data, or configuration.

**Delegation.** Work directly by default. Delegate independent or lengthy
investigation when useful and allowed, giving each delegate one bounded
question and consolidating its evidence.

**Answer.** State the answer, the evidence needed to trust it, its implications
for the larger task, and any important uncertainty.

**Completion.** Finish when the available evidence supports the answer and
material uncertainty is explicit. Stop at resolving the knowledge gap; do not
make the downstream decision or implement work unless separately requested.
