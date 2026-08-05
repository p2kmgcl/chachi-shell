---
name: rebase
description:
  Start or complete a rebase that updates the current branch onto a target. Use
  when the user asks to rebase, an active rebase needs completion, or another
  workflow needs the current branch updated onto a target.
---

Update the current branch onto a chosen target and leave the repository in a
successfully rebased state, resolving straightforward conflicts and involving
the user when substantive behavior requires a decision.

**Choose the target.** Resume an active rebase. Otherwise, infer the target when
the conversation or repository makes it unambiguous; ask when it does not.

**Resolve conflicts.** Resolve directly when the intended combined behavior is
clear. Ask for a decision when the resolution requires choosing between
substantive behaviors.

**Finish.** Continue until the rebase succeeds. Confirm that no rebase remains
active and that the current branch is rebased onto the target. Report blockers
with the context needed to resolve them.
