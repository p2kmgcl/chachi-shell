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

**Lifecycle.** Agent documentation moves from conversation and investigation
through `grill-me` to `write-docs`, turning working context into permanent
codebase documentation for agents and humans.

**Delegation.** `delegate` passes the task and relevant context directly in a
new Pi agent's initial prompt in a new Seniore workspace. The agents coordinate
through Seniore peer messages, without intermediate handoff files. The original
session is deleted only after the replacement confirms it has begun the work.

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

- **[`rebase`](./skills/rebase/SKILL.md).** Update the current branch through a
  rebase and resolve simple conflicts.
- **[`commit`](./skills/commit/SKILL.md).** Record a coherent change as one or
  more atomic commits.
- **[`push`](./skills/push/SKILL.md).** Publish the current branch and create or
  update its pull request.

**Planning and investigation.**

- **[`grill-me`](./skills/grill-me/SKILL.md).** Lead a conversation to reach
  common ground on a plan, decision, or idea.
- **[`diagnose`](./skills/diagnose/SKILL.md).** Find and explain the evidenced
  cause of unexpected software behavior.
- **[`research`](./skills/research/SKILL.md).** Resolve a bounded local or
  external knowledge gap so a larger task or decision can continue.
- **[`review-code`](./skills/review-code/SKILL.md).** Review current repository
  changes through focused lenses.
- **[`review-pull-request`](./skills/review-pull-request/SKILL.md).** Review a
  GitHub pull request and prepare a pending inline review.
- **[`improve-architecture`](./skills/improve-architecture/SKILL.md).** Maintain
  a codebase by clarifying its structure, updating documentation, and
  simplifying its design.

**Authoring.**

- **[`create-ticket`](./skills/create-ticket/SKILL.md).** Create one or more Jira
  tickets from the conversation.
- **[`write-code`](./skills/write-code/SKILL.md).** Produce or modify code using
  the shared coding discipline.
- **[`write-docs`](./skills/write-docs/SKILL.md).** Produce or update
  documentation.
- **[`write-agent-instructions`](./skills/write-agent-instructions/SKILL.md).**
  Produce or refine instructions written for agents.

**Conversation control.**

- **[`delegate`](./skills/delegate/SKILL.md).** Transfer the task and context to
  a new Seniore workspace and Pi agent, then retire the original session after
  confirmation.
- **[`slowdown`](./skills/slowdown/SKILL.md).** Reframe the conversation with
  shorter exchanges and one decision at a time.
- **[`what-do-you-mean`](./skills/what-do-you-mean/SKILL.md).** Expand an
  unresolved statement or question with the context needed to continue the
  conversation.
