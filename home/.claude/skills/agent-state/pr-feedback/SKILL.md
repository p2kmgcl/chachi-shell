---
user-invocable: false
disable-model-invocation: true
---

# PR Review Feedback

Single file that tracks PR review feedback through its lifecycle via a `status` field.

## pr-feedback.json

```json
{
    "status": "pending",
    "pr_url": "{pr-url}",
    "pr_number": "{pr-number}",
    "branch": "{branch-name}",
    "generated_at": "{ISO-8601-timestamp}",
    "latest_review": {
        "author": "{username}",
        "state": "{APPROVED|CHANGES_REQUESTED|COMMENTED}",
        "submitted_at": "{ISO-8601-timestamp}",
        "body": "{review-body-or-empty}",
        "inline_comments": [
            {
                "path": "{file-path}",
                "line": "{line-or-null}",
                "body": "{comment-body}",
                "diff_hunk": "{code-context}",
                "created_at": "{ISO-8601-timestamp}"
            }
        ],
        "comment_count": "{number}"
    }
}
```

If no reviews exist, `latest_review` is `null`.

## Status lifecycle

| Status | Meaning |
|--------|---------|
| `pending` | Fresh review fetched, not yet processed |
| `accepted` | Feedback incorporated into plan |

Deleted after the PR is updated.
