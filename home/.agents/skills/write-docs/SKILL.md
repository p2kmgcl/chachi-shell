---
name: write-docs
description:
  Create or update durable codebase documentation for a package or aspect
  inferred from the conversation. Use when the user asks to document the
  codebase or when established knowledge belongs in permanent repository docs.
---

Create or update durable codebase documentation for the package or aspect
established by the conversation, giving humans and agents an accurate long-term
explanation that fits the repository's documentation system.

**Target.** Infer the subject, purpose, and intended readers from the
conversation. Inspect the relevant implementation and surrounding code to learn
what the documentation needs to explain.

**Context.** Read repository instructions and nearby or related documentation
before choosing the content and format.

**Conventions.** Follow the repository's established location, structure,
language, linking, examples, and documentation tooling. Use its generator or
scaffold when one supports the target.

**Placement.** Extend the canonical existing documentation when it covers the
target. Give a subject that needs its own durable home a new document in the
established location, connected through the repository's navigation and linking
patterns.

**Accuracy.** Align the documentation with the implementation. When the
conversation and implementation materially conflict, explain the discrepancy
and resolve it with the user before finalizing the content.

**Validation.** Compare claims and examples with the implementation, read the
result in its surrounding documentation, and run every applicable documentation
generator, build, or validation command. Finish with accurate, integrated
documentation and successful checks.

**Promotion.** After the durable documentation passes validation, inspect
`.agent-state/` for temporary material it supersedes. Remove fully promoted
files and trim promoted portions from working documents that still contain
useful active context.
