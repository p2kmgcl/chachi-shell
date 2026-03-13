---
user-invocable: false
disable-model-invocation: true
---

# plan.json — Execution Plan

Stores the ordered list of pending and completed tasks for the current ticket.

## Format

```json
{
    "ticket": "TICKET-123",
    "title": "Short description of the plan goal",
    "source": "Where the plan was derived from (e.g., rfc.md, pr-feedback.json)",
    "pending_tasks": [
        {
            "id": 1,
            "action": "What to do — imperative, specific, ~1 sentence",
            "files": ["file1.tsx", "file2.ts"],
            "rfc_section": "RFC section this task implements (e.g., Case 2: BitsAssessmentFeedbackModal)",
            "references": ["rfc.md:88-93", "SomeFile.tsx:120-145"]
        }
    ],
    "completed_tasks": [
        {
            "id": 1,
            "action": "What was planned — same as the original pending task action",
            "files": ["file1.tsx", "file2.ts"],
            "rfc_section": "RFC section this task implemented",
            "commit": "abc1234 conventional commit message",
            "summary": "What actually happened — brief description of the implementation"
        }
    ]
}
```

## Field descriptions

### Pending task fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | yes | Incrementing integer, unique across pending + completed |
| `action` | yes | Imperative description of what to do. Specific enough for an autonomous developer agent. |
| `files` | yes | Files that will be modified or created |
| `rfc_section` | yes | Which RFC section this task traces back to. Used for reconciliation when RFC changes between cycles. |
| `references` | no | File:line pointers to patterns, examples, or relevant code to follow |

### Completed task fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | yes | Same id as the original pending task |
| `action` | yes | Preserved from the original pending task |
| `files` | yes | Preserved from the original pending task |
| `rfc_section` | yes | Preserved from the original pending task |
| `commit` | yes | Short hash + commit message (e.g., `"abc1234 feat(x): add Y"`) |
| `summary` | yes | What the developer actually implemented — may differ from original action |

## Notes

- `pending_tasks` is ordered — task-dispatcher may reorder for implementation ease
- `completed_tasks` preserves the original task fields for RFC reconciliation on reruns
- When the plan-creator runs on a rerun, it compares completed tasks' `rfc_section` against the current RFC to detect scope changes
