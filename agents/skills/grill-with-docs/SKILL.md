---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

## Domain awareness

> **`.agent-state/` is local-only and is not committed to the repo.** It is gitignored and exists only on the current machine. Never reference `.agent-state/` paths from committed artifacts — source code, comments, PR descriptions, commit messages, issues, RFCs, or any docs that ship with the repo. The contents are for agent context only; if a fact belongs in the repo, write it in the actual codebase or in committed docs instead.
>
> **For the same reason, prefer putting domain knowledge in agent-facing markdown files that live inside the repo** (e.g., `AGENTS.md`, `CLAUDE.md`, package-level `AGENTS.md`, or other committed docs) so project-wide information is shared with teammates and survives across machines. Reach for `.agent-state/CONTEXT.md` or `.agent-state/adr/` only when the information is genuinely agent-scratchpad state — not when it's something the team should also see.

During codebase exploration, also look for existing documentation:

### File structure

All domain documentation lives under `.agent-state/`. Most repos have a single context:

```
/
└── .agent-state/
    ├── CONTEXT.md
    └── adr/
        ├── 0001-event-sourced-orders.md
        └── 0002-postgres-for-write-model.md
```

If a `.agent-state/CONTEXT-MAP.md` exists, the repo has multiple contexts. The map points to where each one lives:

```
/
├── .agent-state/
│   ├── CONTEXT-MAP.md
│   └── adr/                              ← system-wide decisions
├── src/
│   ├── ordering/
│   │   └── .agent-state/
│   │       ├── CONTEXT.md
│   │       └── adr/                      ← context-specific decisions
│   └── billing/
│       └── .agent-state/
│           ├── CONTEXT.md
│           └── adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `.agent-state/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `.agent-state/CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update `.agent-state/CONTEXT.md` inline

When a term is resolved, update `.agent-state/CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Don't couple `.agent-state/CONTEXT.md` to implementation details. Only include terms that are meaningful to domain experts.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
