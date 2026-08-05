---
name: push
description:
  Push the current branch and create or update its GitHub pull request. Use when
  the user asks to publish branch changes or an active workflow has completed
  work ready for remote publication.
---

Publish the current branch and leave its GitHub pull request as an up-to-date,
reviewable description of the branch's complete current state.

**Push the branch.** Push to the configured upstream remote. When the branch has
no upstream, infer the repository’s primary remote and establish an upstream
with the same branch name. Use a normal push for fast-forward history and
`--force-with-lease` when rewritten history requires force.

**Create or update the PR.** Use the `gh` CLI for every GitHub operation. Create
a draft PR when the branch has none. Keep the review state of an existing PR.

**Refresh the PR.** After each push, regenerate the title and body from the
complete branch diff against the PR base. Make the title imperative and shorter
than 70 characters. Follow [PR-DESCRIPTION.md](./PR-DESCRIPTION.md) for the
body. Treat commit history as the detailed change record and the PR description
as a cohesive overview of the branch’s current state.

**Finish.** Return the PR URL.
