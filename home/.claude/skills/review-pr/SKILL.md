---
user-invocable: true
argument-hint: "<pr-url>"
description: "Review a GitHub PR and create a pending (draft) review with inline comments"
---

Three strict phases: **Analyze, Discuss, Post.** Do not skip ahead.

1. Fetch PR metadata and diff the base branch against the PR head.
2. **Scope to owned files only.** Read CODEOWNERS, look up the current `gh` user, and only review
   files owned by the user or their teams. Mention skipped files briefly. Ask the user if none match.
3. Analyze owned changes deeply. Use subagents and tools liberally to build context -- read full
   source files, explore related code, find similar patterns in owned files, and check how changes
   interact with the rest of the codebase. Don't limit yourself to the diff. Follow agent
   instructions for review priorities.
4. Present a high-level assessment grouped by theme (concerns, risks, questions about intent). If
   the PR is clean, say so. Do **not** list file paths or line numbers yet -- keep it at the level
   of ideas.
5. **Discuss** the PR with the user. Focus on PR changes, not pre-existing code. Do **not** post
   anything to GitHub. Continue until the user explicitly says to post.
6. When told to post, turn discussed concerns into inline comments.
   - Comment style: short, direct, human-sounding, conversational. No em dashes. Only include a
     snippet if the fix isn't obvious.
   - Write a review payload to a temp file and POST via
     `gh api repos/{owner}/{repo}/pulls/{number}/reviews`:
     ```json
     {
       "body": "Overall summary",
       "comments": [
         { "path": "file.ts", "line": 42, "side": "RIGHT", "body": "Comment" }
       ]
     }
     ```
   - **Omit `event`** to create a pending (draft) review. `side` must be `"RIGHT"`, `line` is the
     line in the new file. All comments must be in this single payload.
7. Clean up the temp file and the `pr-{number}` branch. Tell the user the review is **PENDING** and
   they must submit it on GitHub.
