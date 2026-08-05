# Agent Instructions

Product-agnostic agent resources live here so multiple AI CLIs can reference the
same instructions without depending on a vendor-specific dotfiles path.

## Reference

- https://github.com/mattpocock/skills

## Layout

- `skills/`: canonical reusable task instructions.
- `AGENT-STATE.md`: shared conventions for local, short-term agent context.

The dotfiles installer exposes the canonical skills through
`home/.agents/skills`, which is a symlink to `agents/skills/`, then links that
path to `~/.agents/skills`.

Agent discovers the same `~/.agents/skills` user skill location automatically.

Other tools can point at `agents/skills/` directly.

## Documentation

**Lifecycle.** Agent documentation follows `to-handoff → grill-me → write-docs`,
moving from temporary agent-only state to permanent codebase documentation for
agents and humans.

**Handoffs.** `to-handoff` preserves the current context under
[`.agent-state/`](./AGENT-STATE.md). These local, short-term files optimize
information retention and use whatever structure best serves the next agent.

**Grilling.** `grill-me` combines relevant handoffs, the conversation, and
existing codebase documentation to resolve the information needed for the
current plan or design.

**Codebase documentation.** `write-docs` creates durable documentation for one
package or aspect of the codebase. It inspects nearby examples and repository
conventions before choosing the content and format.

## Skills

Skill directories remain flat under `skills/`. Agent may select any skill when
its description matches the task, and users may invoke any skill explicitly.

**Git operations.**

- **`rebase`.** Update the current branch through a rebase and resolve simple
  conflicts.
- **`commit`.** Record a coherent change as one or more atomic commits.
- **`push`.** Publish the current branch and create or update its pull request.

**Planning and investigation.**

- **`grill-me`.** Lead a conversation to reach common ground on a plan,
  decision, or idea.
- **`diagnose`.** Find and explain the evidenced cause of unexpected software
  behavior.
- **`research`.** Resolve a bounded local or external knowledge gap so a larger
  task or decision can continue.
- **`review-code`.** Review current repository changes through focused lenses.
- **`review-pull-request`.** Review a GitHub pull request and prepare a pending
  inline review.
- **`improve-architecture`.** Maintain a codebase by clarifying its structure,
  updating documentation, and simplifying its design.

**Authoring.**

- **`create-ticket`.** Create one or more Jira tickets from the conversation.
- **`write-code`.** Produce or modify code using the shared coding discipline.
- **`write-docs`.** Produce or update documentation.
- **`write-agent-instructions`.** Produce or refine instructions written for
  agents.

**Conversation control.**

- **`to-handoff`.** Capture the conversation context in a local file so another
  agent can continue the work.
- **`slowdown`.** Reframe the conversation with shorter exchanges and one
  decision at a time.
- **`what-do-you-mean`.** Expand an unresolved statement or question with the
  context needed to continue the conversation.
