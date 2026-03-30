---
user-invocable: true
argument-hint: "<pr-url>"
description: "Review a GitHub PR and create a pending (draft) review with inline comments"
---

Three strict phases: **Analyze, Discuss, Post.** Do not skip ahead.

1. Fetch PR metadata (description, CI status, existing reviews) and diff the base branch against
   the PR head.
2. **Scope to owned files only.** Read CODEOWNERS, look up the current `gh` user, and only review
   files owned by the user or their teams. Mention skipped files briefly. Ask the user if none match.
3. Analyze owned changes deeply. Use subagents and tools liberally to build context -- read full
   source files, explore related code, find similar patterns in owned files, and check how changes
   interact with the rest of the codebase. Don't limit yourself to the diff. Follow agent
   instructions for review priorities.
4. **Present an overview.** Assume the user hasn't looked at the PR yet. Include:
   - What the PR does and why (from description + actual changes).
   - CI status -- pass/fail, and what's failing if relevant.
   - Existing reviews -- approvals, requested changes, or open threads worth knowing about.
   - A short list of areas worth discussing -- one line each. Signal which items carry more risk
     and why (share what you learned from the codebase that makes it important).
   Keep each item brief. If the PR is clean, say so.
5. **Discuss interactively.** Let the user drive by asking about specific areas. Keep each response
   focused -- one concern at a time, at the depth that fits the question. Include short code
   snippets when they help, but don't dump everything at once. Focus on PR changes, not
   pre-existing code. Do **not** post anything to GitHub. Continue until the user explicitly says
   to post.
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
