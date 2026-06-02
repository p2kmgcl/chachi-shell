---
name: review-pr
description: "Reviews a GitHub PR and creates a pending review with editorially gated inline/body findings. Use when the user asks to review a PR or create a draft GitHub review."
---

Four strict phases: **Fetch, Analyze, Discuss, Post.** Do not skip ahead.

## Phase 1 — Fetch

1. Fetch PR metadata (description, CI status, existing reviews).
2. Record the current branch name, then check out the PR branch: `gh pr checkout <number>`.
   If the checkout fails, stop and tell the user — do not proceed to analysis.
3. Fetch the diff once: `gh pr diff <number> > /tmp/pr-<number>.diff`.

## Phase 2 — Analyze (fan-out)

4. List all files in the `lenses/` directory next to this skill. Spawn one subagent per lens file
   with this prompt (do not read the lens file yourself). Lens output is candidate material, not
   review output:

   ```
   Review the changes in PR #<number> in <owner>/<repo>. The PR branch is checked out locally.
   The diff is at /tmp/pr-<number>.diff — read it first before exploring the codebase.
   PR description: <description>
   Follow the instructions in @PRIORITIES.md and @lenses/<LENS_FILE>.
   You may read any file in the codebase to build context.
   ```

   Run all subagents in parallel.
5. Collect findings. Each finding has a priority (P0–P3) defined in `PRIORITIES.md`. Apply these
   rules to the collected candidates:
   - **Suppress all P3 findings** — do not surface them to the user or post them to GitHub.
   - Deduplicate: if two lenses flag the same issue, merge into one finding and preserve all
     contributing lens names — the merged comment will carry one Shields badge whose label is the
     priority and whose message is the joined lens list (e.g. `![P1 SECURITY・BUGS](https://img.shields.io/badge/P1-SECURITY%E3%83%BBBUGS-orange)`).
   - Reassess priority after deduplication. Multiple candidates can raise priority only when the
     merged consequence is stronger, not merely because the count is higher.
   - Apply `EDITORIAL.md`. Discard candidates that fail the editorial gate. For every kept finding,
     decide whether it belongs inline or in the review body.

## Phase 3 — Present & Discuss

6. **Present an overview** to the user. Assume they haven't looked at the PR yet. Include:
   - What the PR does and why (from description + actual changes).
   - CI status — pass/fail, and what's failing if relevant.
   - Existing reviews — approvals, requested changes, or open threads worth knowing about.
   - Kept findings only, sorted by priority. For each: one-line summary, location or review-body
     placement, and the same priority/lens badge that would be posted. Lead with P0s prominently. If no P0/P1
     findings exist, say so explicitly.
7. **Discuss interactively.** Let the user drive by asking about specific findings or areas. Keep
   each response focused — one concern at a time. Do **not** post anything to GitHub yet.
   Continue until the user explicitly says to post.

## Phase 4 — Post

8. Turn every kept finding into a single pending review. Use inline comments for line-local findings
   and the review body for non-line-local findings. See `POSTING.md` for format and style rules.
9. Delete `/tmp/pr-<number>.diff`. Check out the original branch and delete the `pr-{number}`
   branch. Tell the user the review is **PENDING** and they must submit it on GitHub.
