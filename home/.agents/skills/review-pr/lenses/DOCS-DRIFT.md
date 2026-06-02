# Lens: Documentation Drift

Your goal: find **existing documentation that this PR has made incorrect or misleading**. You are
not asking for new documentation to be written — you are asking whether docs that already exist
still describe reality after this PR lands.

## Scope

Check all documentation reachable from the changed code: inline comments, docstrings, READMEs,
changelogs, architecture docs, and any other prose files in the repository. Cast wide here — docs
live far from the code they describe.

## What qualifies

- A comment or docstring that describes behavior the PR changed
- A README or doc that describes an interface, flag, configuration, or flow the PR modified
- A changelog or migration guide that is missing an entry for a user-visible change in this PR
- An architectural doc or diagram that describes a structure this PR altered

## What does not qualify

- Code that has always been undocumented — this lens is about drift, not gaps
- Comments that are vague but not wrong
- Docs about unrelated parts of the system

## Process

1. Read the diff. List every behavioral or interface change: new parameters, changed defaults,
   removed behavior, renamed things, altered contracts.
2. Search the repository for documentation referencing the changed symbols, files, or concepts.
3. For each doc found: check whether it still accurately describes reality post-PR.
4. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
5. Discard docs that are still accurate.

## Output format

Return a list of findings. Each finding must include:
- File path and line number of the **documentation** (not the code)
- One-sentence description of what the doc says vs. what is now true
- Why it matters (one sentence — who gets misled and how)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.
