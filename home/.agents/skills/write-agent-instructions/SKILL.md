---
name: write-agent-instructions
description:
  Write or refine concise, predictable instructions for agents. Use when
  creating or editing a skill, AGENTS.md, or any agent-facing reference or
  prompt that directs behavior.
---

Write agent-facing documents that lead an agent toward a clear outcome through
dense, self-contained instructions whose structure reflects when each behavior
is needed.

**Skill branch.** When the document is a skill, read
[`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) for Codex frontmatter, invocation,
package metadata, and validation.

**Behavioral density.** Express every required behavior in the fewest words
that remain clear and unambiguous. Use precise, familiar leading words to anchor
repeated concepts and replace repeated explanations. Shorten only when meaning
is preserved.

**Opening.** Begin the body with a plain paragraph that explains the goal and
scope of the entire file.

**Paragraphs.** Give each following paragraph one specific aspect of the goal
and begin it with bold words stating its purpose.

**Structure.** Use lists or delimiters only when needed to express a boundary,
sequence, or hierarchy.

**Context pointers.** State what the referenced material provides and each
distinct condition for reading it. Front-load language that connects the
agent's task to those conditions and express each real branch once.

**Information hierarchy.** Distinguish ordered steps from reference material.
Keep behavior needed by every branch in the main document and place
branch-specific reference behind context pointers. Co-locate each concept with
its definitions, rules, and caveats.

**Context.** Assume the original writing context will be unavailable. Keep each
required meaning in one authoritative place and point to it elsewhere. Include
unwritten conventions, reasons, and gotchas; rely on general knowledge and
cheap environment lookups for information the agent can reliably discover.

**Goal over path.** State the intended behavior, authorized scope, completion
conditions, and essential constraints. Give one clear default and add branches
where behavior must differ. Describe the desired behavior so completely that
the agent can act without considering irrelevant alternatives. Prescribe steps
when correctness, safety, or consistency depends on them, ending each step with
a checkable and appropriately exhaustive completion condition.

**Rewrite first.** Test instructions against concrete cases. When behavior
fails, determine whether the cause is wording, priority, conflict, or missing
behavior. Rewrite or remove existing text before adding rules. Prune every
stale, duplicated, irrelevant, or default instruction that does not materially
change behavior, and add words only for missing behavior.
