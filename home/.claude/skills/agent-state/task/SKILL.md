---
user-invocable: false
disable-model-invocation: true
---

# task.json — Current Task

Stores the description and execution log of the task currently being worked on.

## Format

```json
{
    "description": "{task-description}",
    "log": ["{action-1}", "{action-2}"]
}
```

Created fresh for each task. Only the `log` array may be modified — `description` is immutable.

## Log Prefixes

| Prefix | Meaning |
|--------|---------|
| `COMPLETED:` | Task implemented and committed |
| `ERROR:` | Implementation error |
| `BLOCKER:` | Cannot proceed, needs replanning |
| `REVIEW_SUCCESS:` | Code review passed |
| `REVIEW_ERROR:` | Code review found issues |
| `VALIDATION_SUCCESS:` | Full validation passed |
| `VALIDATION_ERROR:` | Validation failed |
