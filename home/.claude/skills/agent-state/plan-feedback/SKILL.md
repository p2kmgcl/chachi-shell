---
user-invocable: false
disable-model-invocation: true
---

# plan-feedback.json — Validation Failure Details

Stores detailed failure information when issues are found during full-plan validation.

## Format

```json
{
    "generated_at": "{ISO-8601-timestamp}",
    "status": "FAILED",
    "issues": [
        {
            "type": "code_review | validation_error",
            "description": "{detailed description}",
            "files": ["{affected-file-1}"],
            "suggestion": "{how to fix}"
        }
    ],
    "summary": "{overall summary of failures}"
}
```

Replaced entirely on each validation run.
