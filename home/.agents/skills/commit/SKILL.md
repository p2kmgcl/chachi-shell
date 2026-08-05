---
name: commit
description:
  Commit current changes as one or more atomic logical units. Use when the user
  asks to commit work or an active workflow has completed a coherent change that
  should be recorded.
---

Record the conversation's completed work as atomic, independently coherent
commits whose scope, messages, and human attribution match the repository's
established conventions.

**Inspect first.** Examine all candidate changes—including staged, unstaged, and
untracked files—and recent commits for repository conventions. Infer scope from
the conversation and diff. Limit the commit scope to related, understood
changes. Proceed directly when scope is clear and ask when ambiguity makes a
correct commit impossible.

**Group logically.** Each commit must be independently coherent and reversible
without leaving the repository broken. Separate unrelated fixes, features,
refactors, or configuration changes. “And” in a proposed message is a smell:
reconsider whether the commit should be split.

**Stage precisely.** Stage only the paths or hunks belonging to the current
commit. Split changes within a file when doing so produces more accurate,
independently valid commits. Review the staged diff before committing.

**Match repository style.** Use recent commit history as a signal for message
format and tone, not as a rigid template.

**Attribution.** Use only established human contributor attribution. Keep the
message focused on the repository change and its intent.
