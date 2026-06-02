# Posting a GitHub Review

## API call

Write the review payload to a temp file, then POST via:

```
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

Payload shape:

```json
{
  "body": "Overall summary (1-2 sentences, mention P0/P1 count or 'no blocking issues')",
  "comments": [
    { "path": "file.ts", "line": 42, "side": "RIGHT", "body": "[P0][SECURITY] Comment text" }
  ]
}
```

**Omit `event`** to create a pending (draft) review. `side` must be `"RIGHT"`. `line` is the
line number in the new file. All comments must be in this single payload.

## Comment style

- Prefix every comment with its priority label followed by the contributing lens tag(s):
  `[P0][LENS-NAME]` or `[P0][LENS-A][LENS-B]` when multiple lenses flagged the same issue.
  The lens name is the uppercase filename stem of the lens file (e.g. `SECURITY`, `TEST-COVERAGE`).
- Short, direct, human-sounding. No em dashes.
- One issue per comment — do not bundle multiple concerns.
- Skip the snippet if the fix is obvious from context. Include one only when it clarifies the fix.
- Do not comment on pre-existing code not touched by the PR.
- Do not explain what the code does — only what's wrong and why it matters.

## What to include

- P0 and P1 findings: always include.
- P2 findings: include unless the user said to skip them during discussion.
- P3 findings: never include.
