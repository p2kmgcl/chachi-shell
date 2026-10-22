---
name: retro
description:
  Review a coding session and propose evidence-backed improvements to the
  agent's environment and workflows. Use when the user asks for a retrospective,
  wants to learn from repeated corrections, or wants future agent runs to work
  better.
---

Review a coding session to identify changes to the agent's environment that
would make future runs more reliable and efficient. Recommend improvements,
not application-code refactors, and remain read-only until implementation is
separately approved.

**Scope.** Review the session named by the user, defaulting to the current one.
Read the available conversation, tool results, relevant diffs, and referenced
local logs. State gaps in the record instead of reconstructing unavailable
activity. Distinguish agent mistakes from user changes in requirements and
unavoidable constraints.

**Inspect.** Follow concrete friction: repeated corrections, failed checks,
wrong turns in navigation, missing information, costly tool calls, and lost
context. Inspect the relevant repository instructions, documentation, tools,
verification commands, hooks, and CI before proposing replacements. Include
successful practices only when they suggest a reusable improvement.

**Guardrails.** Prefer deterministic checks for mechanically detectable
mistakes. First check whether an existing guardrail was skipped, broken, or
unwired; repair or connect it rather than duplicate it. Consider missing
automation when it would prevent an evidenced failure, not as a generic
requirement for every repository. Reserve prose rules for genuine judgement
calls that checks cannot adequately enforce.

**Instructions.** For steering changes, apply the
[agent-writing guidance](../write-agent-instructions/SKILL.md). Rewrite or
remove conflicting, ineffective, or duplicated instructions before adding more.
Keep repository-specific knowledge in repository docs and generic workflow
behavior in its owning skill; use navigation pointers instead of copying
reference material into global instructions.

**Tools and access.** Consider focused navigation aids, simpler tool calls,
reusable diagnostics, and better access to relevant logs or documentation.
Prefer existing tools and the least privilege needed. Do not recommend broader
access, new dependencies, or persistent infrastructure without an evidenced
benefit and their security and maintenance costs.

**Findings.** Rank a small set of actionable candidates by expected impact,
recurrence, and implementation cost. For each, cite the session evidence,
explain the cause of the friction, name the smallest proposed change and its
owning file or tool, and state how to verify improvement. Distinguish observed
facts from uncertain explanations. Do not invent findings to fill categories.

**Completion.** Return the ranked recommendations and material evidence gaps.
If no worthwhile change is supported, say so. Stop before editing files,
installing tools, or starting another workflow; the user chooses the next action.
