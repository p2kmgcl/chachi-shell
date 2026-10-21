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
handoff files. Preserve the user's task, constraints, findings and evidence,
decisions and reasons, relevant paths, attempts and verification results,
existing approvals, unresolved questions, and next steps. Distinguish facts
from assumptions and omit secret values.

**Task.** Ask the replacement to carry out the task in its new workspace,
respecting repository instructions and pending user approvals. Tell it how to
contact your session, to confirm directly once it has understood the context
and begun a concrete step, and to continue without waiting for you. It should
execute the task, not repeat this delegation workflow.

**Retirement.** Wait for that explicit confirmation from the replacement;
message delivery or session activity alone is insufficient. Then tell the user
where the work continues and delete only your original session, not its
workspace or other sessions. If the replacement reports a blocker, delegation
fails, or confirmation has not arrived, keep your session available.
