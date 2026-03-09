---
user-invocable: true
argument-hint: "<pr-url>"
description: "Review a GitHub PR and create a pending (draft) review with inline comments"
---

# Review a GitHub Pull Request

You are reviewing a GitHub PR. Follow these three phases strictly.

---

## Phase 1: Fetch & Analyze

### 1. Fetch PR data and diff

```bash
gh pr view $ARGUMENTS --json title,body,number,baseRefName,headRefName,files
git fetch origin pull/{pr_number}/head:pr-{pr_number}
git diff {baseRefName}...pr-{pr_number}
```

### 2. Filter by code ownership

Only review files that our team owns. To determine ownership:

1. Read `.github/CODEOWNERS` (or `CODEOWNERS` at repo root) with the Read tool.

2. Look up the current authenticated user's GitHub username:
   ```bash
   gh api user --jq '.login'
   ```

3. Parse the CODEOWNERS file and match each changed file from the PR against the ownership rules.
   CODEOWNERS uses a last-match-wins pattern (like `.gitignore`).
   For each changed file, find the last matching pattern and check if the current user (or any of their teams) is listed as an owner.

4. Review owned files, mention skipped unowned files briefly in the assessment, and ask the user if none of the changed files are owned.

### 3. Analyze the PR diff and description deeply

- Only analyze owned changes.
- When a change is hard to understand without surrounding context,
  use the Read tool to read the full source file.
- Look for potential issues analyzing the whole code base, do not focus just on the diff.
- Follow agent instructions to determine which are the more critical things to check.

### 4. Present findings

Present a high-level assessment:

- What the PR does and its scope
- Key concerns grouped by theme (e.g. "there's a potential race condition in the queue worker", "the new endpoint doesn't validate input")
- Risk areas and questions about the author's intent
- If unowned files were skipped, mention them briefly
- If the PR looks clean, say so, don't invent issues

Do **NOT** list individual comments with file paths, line numbers, or severity tags at this stage.
Keep the discussion at the level of ideas and concerns, not review comments.

## Phase 2: Discussion

- Have a high-level conversation about the PR: its approach, concerns, tradeoffs, and open questions.
- You can read additional files or explore the codebase deeper if the user asks or if it helps clarify a point.
- Discussion should go around the changes related to the PR, not existing code.
- Check agent instructions to determine which aspects of the PR should you focus on.
- When checking our owned files, look for similar files owned by us to see if they are following our patterns.
- We can safely ignore files that are not owned by us, even if they have issues.
- **Do NOT post anything to GitHub during this phase.**
- Continue until the user explicitly says to post (e.g. "post it", "submit", "looks good, send it").

## Phase 3: Post to GitHub

When the user gives the go-ahead:

### 1. Create inline comments from the discussion

Based on the discussion, create specific inline review comments.
For each concern that was discussed and agreed upon,
identify the exact file and line number in the diff.

Write comments that sound human-made:
- Keep them short and direct, one or two sentences is usually enough
- Don't repeat code that's already visible in the diff, the reviewer is looking at it
- Don't over-explain or add unnecessary context, state the issue and why it matters
- Only include a code snippet if the fix isn't obvious from the explanation alone
- Use a natural, friendly, conversational tone
- Never use em dashes.

### 2. Build the JSON payload

Write the review payload to a temp file. **Do NOT include an `event` field**, omitting
it is what creates a pending (draft) review.

```json
{
  "body": "Overall assessment summary text here",
  "comments": [
    {
      "path": "relative/file/path.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "This can return null when the list is empty — worth adding a guard here."
    }
  ]
}
```

Non-obvious bits:
- Omitting `event` creates a draft review
- `side` must be `"RIGHT"`
- `line` is the line number in the **new file** (the `+` side of the diff)
- All inline comments must be included in this payload,
  you cannot add comments to a pending review after creation.

### 3. Post the review

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews \
  --method POST --input /tmp/pr-review-payload.json
```

### 4. Clean up and report

```bash
rm -f /tmp/pr-review-payload.json
git checkout - && git branch -D pr-{pr_number}
```

Tell the user how many comments were posted, that the review is in **PENDING** (draft) state,
and they need to go to the GitHub PR page and click **"Submit review"** to publish it.
