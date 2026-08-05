---
name: grill-me
description:
  Interview the user about a plan, decision, or idea until reaching confirmed
  common ground. Use when the user wants to sharpen or stress-test their
  thinking, asks the agent to lead with questions, or mentions "grill me".
---

Lead the user to confirmed common ground on a plan, decision, or idea, resolving
the uncertainty they need to choose the next action.

**Context.** Read the shared [agent-state conventions](../../AGENT-STATE.md),
use relevant handoffs and existing documentation, and explore the codebase to
understand the current state.

**Interview.** Examine every relevant branch of the plan or design and resolve
dependent decisions one at a time. Ask one question, include a recommended
answer, and wait for the user's response.

**Ownership.** Resolve discoverable facts through the environment and reserve
questions for decisions the user must make.

**Completion.** When the answers support shared understanding, state that
conclusion and wait for the user to confirm it. The confirmed understanding
completes the session; the user chooses the next action.
