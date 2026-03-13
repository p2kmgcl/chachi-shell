---
user-invocable: false
disable-model-invocation: true
---

# task.json — Current Task

Stores the details and execution log of the task currently being worked on.

## Format

```json
{
    "action": "What to do — imperative, specific",
    "files": ["file1.tsx", "file2.ts"],
    "rfc_section": "RFC section this task implements",
    "references": ["rfc.md:88-93", "SomeFile.tsx:120-145"],
    "log": ["{PREFIX}: {summary}"]
}
```

Created fresh for each task by the task-dispatcher (copying fields from the pending task in plan.json). Only the `log` array may be modified — all other fields are immutable.

## Field descriptions

| Field | Description |
|-------|-------------|
| `action` | What to do — copied from the pending task |
| `files` | Files to modify — copied from the pending task |
| `rfc_section` | RFC section this task traces to — copied from the pending task |
| `references` | File:line pointers for patterns/context — copied from the pending task (may be absent) |
| `log` | Append-only array of prefixed status entries |

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
