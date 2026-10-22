---
name: delegate
description:
  Transfer the current task and context directly to a new Seniore workspace and
  agent, then retire the original session after its replacement confirms it has
  begun. Use when the user asks to delegate or move the current effort to a new
  workspace and hand over execution.
---

Use Seniore to create the workspace, spawn a new agent, coordinate, then
self-destroy once the replacement confirms it has begun the work.

**Context.** Give the replacement a self-contained brief directly, without
handoff files. Preserve the user's goal, agreed scope and solution, constraints,
findings and evidence, decisions and reasons, rejected alternatives, relevant
paths, current execution state, attempts and verification results, existing
approvals, unresolved questions, and next concrete step. State what the user
has already agreed to and the discretion granted; distinguish facts from
assumptions and omit secret values.

**Execution.** Tell the replacement it is continuing an ongoing task, not
starting a new planning conversation. It should begin the next concrete step
and carry out the agreed work autonomously, respecting repository instructions
and inherited approvals rather than asking the user to approve them again.
Preserve genuinely pending approvals; do not invent authorization or reopen
settled decisions. It should execute the task, not repeat this delegation
workflow.

**Coordination.** Tell the replacement how to contact your session and to
confirm directly once it has understood the context and begun a concrete step,
then continue without waiting for you. Explain that your session will disappear
after that confirmation: the replacement owns the task and should ask the user
directly if blocked or if a new decision or approval is needed.

**Retirement.** Wait for that explicit confirmation from the replacement;
message delivery or session activity alone is insufficient. Then tell the user
where the work continues and delete only your original session, not its
workspace or other sessions. If the replacement reports a blocker, delegation
fails, or confirmation has not arrived, keep your session available.
