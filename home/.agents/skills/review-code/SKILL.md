---
name: review-code
description:
  Review current repository changes through parallel focused lenses and return
  aggregated inline findings. Use when the user asks for a code review, wants
  local changes inspected, or another workflow needs code-review findings.
---

Review the current repository changes through independent focused lenses and
return one normalized, evidence-backed set of inline findings for the caller to
consume.

**Scope.** Use the comparison target and paths supplied by the caller.
Otherwise, determine the repository base branch and review all committed,
staged, unstaged, and untracked changes relative to it.

**Analyze.** Run one agent per file in `lenses/`, using the maximum available
parallelism. Give each agent the current repository path, review scope, and
explicit paths to its lens, [PRIORITIES.md](./PRIORITIES.md), and
[LENS_OUTPUT.md](./LENS_OUTPUT.md). Each agent owns its investigation and
evidence quality.

**Aggregate.** Normalize lens output and merge candidates describing the same
underlying issue. Merge their lens names and keep the highest contributed
priority. Advance P0–P2 findings anchored to changed lines and sort them by
priority.

**Return.** Emit `none` or only aggregated findings in the shared output format.
