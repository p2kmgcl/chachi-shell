---
user-invocable: true
description: "Push current branch to remote and create or update a draft PR"
---

1. Invoke `local-rules` skill.
2. Push the current branch to the remote with the same name. Use force-with-lease.
3. Check if a PR already exists for this branch. If not, create a new draft PR. If it
   exists, update its title and body and ensure it stays in draft state.
4. Generate the PR title: short, imperative, under 70 characters.
5. Generate the PR body. Check for PR description instructions in local rules or
   CLAUDE.local.md.
6. Always use the `gh` CLI for GitHub operations. Never use GitHub MCP tools.
7. Return the PR URL.
