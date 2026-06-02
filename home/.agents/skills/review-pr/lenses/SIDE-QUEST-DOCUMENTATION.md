# Lens: Side Quest - Documentation

Your goal: identify **new or changed behavior that is worth documenting inside this repository**.
Ask whether the PR creates a documentation gap that will make the codebase harder to navigate or
use after the PR lands.

## Scope

Focus on documentation in the same repository: READMEs, docs directories, architecture notes,
ADRs, changelogs, guides, docstrings, and other prose files. Explore existing docs as context
before deciding a gap exists. Existing docs often reveal the repo's expectations for what gets
indexed, summarized, or explained.

## Documentation purpose

Documentation should serve at least one of these purposes:

- Discoverability: helping someone find the relevant code, concept, capability, or entry point in
  a large codebase
- Expected usage: explaining how to use a complex feature, flow, configuration, integration, or
  combination of features correctly

Docs are summaries, not duplications. Prefer concise explanations, references, pseudocode, and
links to canonical code over full real-world examples or prose that restates what is obvious from
reading the implementation.

## What qualifies

- A new feature, capability, config option, command, integration, or workflow that has no clear
  repo-local discovery path
- A more complex feature or combination of features whose expected usage is not obvious from the
  changed code alone
- A new architectural concept, subsystem, boundary, or entry point that belongs in an existing
  index, map, guide, or architecture note
- A user-visible or maintainer-visible behavior change that belongs in an established changelog,
  migration guide, release note, or "what changed" document
- A change that follows a repo convention for documenting similar capabilities, but omits the
  matching documentation update

## What does not qualify

- Missing documentation for every new function, class, file, or small behavior change
- Prose that would merely repeat names, types, control flow, or code that is already easy to read
- Full examples when a short explanation, pseudocode, or reference would communicate the idea
  better
- External documentation, unless this repository has an established local pointer or index for it
- Vague "this should be documented somewhere" observations without a concrete reader, need, and
  likely documentation home
- Existing documentation that is now incorrect

## Process

1. Read the diff. List the conceptual and usage-level changes, not every implementation detail.
2. Search existing repository docs for the changed symbols, concepts, subsystems, commands, config
   names, and workflows.
3. Use those docs to infer the repo's documentation conventions and likely insertion points.
4. For each candidate gap: identify the reader who would need the documentation and whether the
   need is discoverability or expected usage.
5. Decide whether a concise summary, reference, pseudocode, or guide would add information not
   already obvious from the code.
6. Apply the priority rubric from `PRIORITIES.md` -- don't assume a priority in advance.
7. Discard anything that is merely nice-to-have, redundant with readable code, or lacks a natural
   repo-local documentation home.

## Output format

Return a list of findings. Each finding must include:

- File path and line number of the changed code that creates the documentation need
- One-sentence description of the missing documentation and where it likely belongs
- Why it matters: who loses discoverability or expected-usage context, and how
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.

## Bias

Be selective. Most changes do not need documentation. Flag only gaps where repository docs would
materially improve navigation or correct usage, and where the missing doc can be stated concisely.
