# Agent State

Agent state provides a shared local workspace for short-lived information that
helps agents continue current work while keeping durable project knowledge in
the codebase.

**Purpose.** `.agent-state/` holds local, short-term working context for agents.
It is gitignored, available only on the current machine, and may remain loosely
organized because its value is immediate continuation rather than long-term
discovery.

**Contents.** Use it for handoffs, conversation dumps, incomplete notes, and
other temporary material that helps an agent continue current work. Let each
workflow choose the structure that best preserves its context.

**Durability.** Place stable knowledge that should remain useful to agents and
humans in the codebase's established documentation. The codebase is the
organized, long-term record; committed artifacts reference that durable record.
Once durable documentation incorporates temporary material, clean the
superseded content from `.agent-state/`.
