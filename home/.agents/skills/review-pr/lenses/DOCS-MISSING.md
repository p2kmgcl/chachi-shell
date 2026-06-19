# Lens: Documentation

Find new or changed behavior in this PR that is worth documenting inside this repository — a gap that will make the codebase harder to navigate or use after the PR lands. Documentation should serve discoverability (finding the relevant code, concept, or entry point) or expected usage (how to use a complex feature, flow, or integration correctly). Docs are summaries, not duplications — prefer concise explanations, references, and pseudocode over prose that restates readable code.

## Examples

`cli/deploy.py:L20: discoverability: new "deploy --canary" command has no entry in docs/commands.md. Users won't find it. [P2]`

`integrations/stripe.py:L45: usage: multi-step webhook setup is non-obvious from the code. Belongs in the integrations guide. [P2]`

`core/scheduler.py:L12: concept: new retry-backoff subsystem has no mention in the architecture map it logically belongs to. [P3]`

## Process

1. Read the diff. List the conceptual and usage-level changes, not every implementation detail.
2. Search existing repository docs for the changed symbols, concepts, subsystems, commands, config names, and workflows.
3. Use those docs to infer the repo's documentation conventions and likely insertion points.
4. For each candidate gap: identify the reader who needs it and whether the need is discoverability or expected usage.
5. Apply the priority rubric from `PRIORITIES.md`.

## Priority

- **P2**: a reader hitting this feature or flow has no way to use it correctly, or no way to discover something non-obvious, without the doc.
- **P3**: convenience doc; the code is already discoverable and usable without it.

Escalate to P2 when the gap genuinely blocks correct usage or discovery. Do not inflate to P2 just to clear the suppression line.

## Boundaries

Flag only gaps with a concrete reader, a clear need (discoverability or expected usage), and an identifiable documentation home in this repository. Summaries, pseudocode, and references qualify — prose that restates readable code does not.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
