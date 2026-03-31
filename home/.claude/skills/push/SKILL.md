---
user-invocable: true
description: "Push current branch to remote and create or update a draft PR"
---

1. Push the current branch to the remote with the same name. Use force-with-lease.
2. Check if a PR already exists for this branch. If not, create a new draft PR. If it
   exists, update its title and body and ensure it stays in draft state.
3. Generate the PR title: short, imperative, under 70 characters.
4. Generate the PR body following any instructions found in CLAUDE.local.md.
5. Always use the `gh` CLI for GitHub operations. Never use GitHub MCP tools.
6. Return the PR URL.
