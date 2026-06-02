---
name: review-pr
description: "Review a GitHub PR and create a pending (draft) review with inline comments"
---

Three strict phases: **Analyze, Discuss, Post.** Do not skip ahead.

## Phase 1 — Fetch

1. Fetch PR metadata (description, CI status, existing reviews).
2. Record the current branch name, then check out the PR branch: `gh pr checkout <number>`.
   If the checkout fails, stop and tell the user — do not proceed to analysis.
3. Fetch the diff once: `gh pr diff <number> > /tmp/pr-<number>.diff`.

## Phase 2 — Analyze (fan-out)

4. List all files in the `lenses/` directory next to this skill. Spawn one subagent per lens file
   with this prompt (do not read the lens file yourself):

   ```
   Review the changes in PR #<number> in <owner>/<repo>. The PR branch is checked out locally.
   The diff is at /tmp/pr-<number>.diff — read it first before exploring the codebase.
   PR description: <description>
   Follow the instructions in @PRIORITIES.md and @lenses/<LENS_FILE>.
   You may read any file in the codebase to build context.
   ```

   Run all subagents in parallel.
5. Collect findings. Each finding has a priority (P0–P3) defined in `PRIORITIES.md`. Apply these
   rules to the collected results:
   - **Suppress all P3 findings** — do not surface them to the user or post them to GitHub.
   - Sort remaining findings P0 → P1 → P2.
   - Deduplicate: if two lenses flag the same issue, merge into one finding and preserve all
     contributing lens names — the merged comment will carry all their tags (e.g. `[P1][SECURITY][BUGS]`).

## Phase 3 — Present & Discuss

6. **Present an overview** to the user. Assume they haven't looked at the PR yet. Include:
   - What the PR does and why (from description + actual changes).
   - CI status — pass/fail, and what's failing if relevant.
   - Existing reviews — approvals, requested changes, or open threads worth knowing about.
   - All findings sorted by priority. For each: one-line summary, file + line, priority label.
     Lead with P0s prominently. If no P0/P1 findings exist, say so explicitly.
7. **Discuss interactively.** Let the user drive by asking about specific findings or areas. Keep
   each response focused — one concern at a time. Do **not** post anything to GitHub yet.
   Continue until the user explicitly says to post.

## Phase 4 — Post

8. Turn discussed concerns (P0–P2 only) into inline comments. See `POSTING.md` for format and
   comment style rules.
9. Delete `/tmp/pr-<number>.diff`. Check out the original branch and delete the `pr-{number}`
   branch. Tell the user the review is **PENDING** and they must submit it on GitHub.
