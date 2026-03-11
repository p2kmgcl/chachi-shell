---
user-invocable: false
disable-model-invocation: true
---

# plan.json — Execution Plan

Stores the ordered list of pending and completed tasks for the current ticket.

## Format

```json
{
    "pending_tasks": ["<ACTION> <FILE> <KEY_DETAILS> | Follow: <REF_FILE>:<LINES> | Use: <UTILITIES> | Update: <RELATED_FILES> | Tests: <TEST_INFO>"],
    "completed_tasks": []
}
```

- Each task is a single string with pipe-delimited sections
- `pending_tasks`: ordered list of tasks yet to be implemented
- `completed_tasks`: summaries of finished work
