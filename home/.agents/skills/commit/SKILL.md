---
name: commit
description:
  Create or rewrite atomic semantic commits from current changes or existing
  branch history. Use when the user asks to commit work, split, squash, reorder,
  or clean up commits, or when an active workflow completes a coherent change
  that should be recorded.
---

Record or rewrite completed work as a dependency-ordered sequence of atomic,
independently coherent commits whose motivations make the final change easy to
review.

**Inspect first.** Examine every candidate change—including staged, unstaged,
and untracked files—and the existing branch history. Infer scope from the
conversation and diff, limit it to related understood work, and ask only when
ambiguity prevents correct grouping.

**Group by motivation.** Give each commit one independently reviewable reason to
exist, not merely a set of related files. Separate behavior changes, fixes,
refactors, configuration, and UX feedback that can be understood or reverted
independently, even when they belong to the same feature or touch the same file.
“And” in a proposed message is a signal to reconsider splitting it.

**Tell the story.** Order prerequisites before their consumers and follow-up
behavior after the feature it changes. When rewriting history, preserve each
semantic step that survives in the final tree, remove superseded implementation
churn, and never fold independently meaningful final behavior into a broader
feature commit. Place each test in the earliest commit whose behavior it proves.

**Stage precisely.** Stage only the paths or hunks for the current motivation;
split changes within a file when needed. Review every staged diff before
committing and review the final log as a sequence, not only as isolated commits.

**Rewrite safely.** Preserve the intended final tree unless the user approved
code changes. Record the original tip or final diff before rewriting, compare it
with the rewritten result, and finish with no rewrite operation or unintended
working-tree changes left active.

**Match repository style.** Use recent commit history as a signal for message
format and tone, not as a rigid template.

**Attribution.** Use only established human contributor attribution. Keep each
message focused on that commit's motivation and intent.
