---
name: review-pull-request
description:
  Review a GitHub pull request in the current local worktree, present its state
  and code findings, and create a pending inline review after approval. Use
  when the user asks to review a pull request or provides a GitHub pull-request
  reference.
---

Review a pull request in the current user-owned worktree, combine its repository
state with focused code findings, and create an approved pending GitHub review
for the user to edit and submit.

**Prepare.** Use the `gh` CLI to fetch the PR description, branch metadata, CI
state, and review state. Confirm the PR belongs to the current repository and
require a clean worktree, including no staged, unstaged, or untracked changes.
Run `gh pr checkout <PR> --detach`, then verify local `HEAD` matches the PR head
SHA. Detached checkout is the default because reviews are read-only and must
not depend on the clone's remote-tracking refspecs. Stop and ask the user if the
repository differs, the worktree is not clean, checkout fails, or the commits
do not match; never stash, reset, discard, or overwrite local state.

**Summarize.** Run one summary agent using [SUMMARY.md](./SUMMARY.md). Combine
its concise “what and why” overview with CI and review state.

**Review.** Read and follow
[the code-review instructions](../review-code/SKILL.md) in this agent. Apply
them to the worktree with the PR base as the comparison target, using subagents
for its lenses.

**Present.** Show the PR overview, CI state, review state, and aggregated inline
findings. Discuss questions one concern at a time. Begin GitHub writes after the
user explicitly approves.

**Post.** Use the `gh` CLI to create one pending review with an empty body and
all findings as inline comments, following [POSTING.md](./POSTING.md). When the
finding set is empty, report a clean review. Synchronize viewed files with
`sync-viewed-files.sh`, passing the current finding paths directly. Treat a
synchronization failure as a warning. Tell the user the review remains pending
for their manual editing and submission.

**Finish.** Leave the PR commit checked out in detached-HEAD state and perform
no branch restoration or worktree cleanup. Report the commit left checked out.
