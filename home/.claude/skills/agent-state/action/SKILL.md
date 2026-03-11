---
user-invocable: false
disable-model-invocation: true
---

# action.json — Next Implementer Action

Stores the next action the implementer should take.

## Format

```json
{
    "action": "<action-name>"
}
```

## Valid Actions

| Action | Meaning |
|--------|---------|
| `develop_task` | Implement current task |
| `review_task` | Review latest commit |
| `validate_plan` | Run full-plan validation |
| `create_complete_pr` | Create/update PR (work complete) |
| `create_incomplete_pr` | Create/update PR (work incomplete) |
| `stop` | Halt — too many consecutive errors |
