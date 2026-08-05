---
name: to-handoff
description:
  Preserve the current conversation and working state in a detailed local file
  so a fresh agent can continue. Use when the user requests a handoff or current
  work is being transferred to another agent or session.
---

Preserve the current context window as a detailed local handoff so a fresh agent
can continue the same effort with its decisions, evidence, state, and next steps
intact.

**Location.** Follow the shared [agent-state conventions](../../AGENT-STATE.md)
and write one file per effort at
`<workspace-root>/.agent-state/handoffs/<descriptive-slug>.md`.

**Source.** Use the conversation and tool results already present in the context
window.

**Dump.** Create the file immediately and capture the retained context with
maximum useful detail and minimal organization. Preserve every actionable fact,
decision, assumption, artifact, result, user constraint, unresolved point, and
next step available.

**Synthesize.** While context remains available, rewrite the same file into one
detailed, self-contained current-state document. Choose the structure that best
fits the conversation, consolidate repetition, and preserve the detail a fresh
agent needs to continue without the original thread.

**Budget.** Prioritize completing a usable dump. Continue into synthesis while
the current context window supports it, and end with the most complete viable
pass before context compaction.

**Secrets.** Represent sensitive values through safe placeholders and the
location or method the next agent can use to retrieve them.
