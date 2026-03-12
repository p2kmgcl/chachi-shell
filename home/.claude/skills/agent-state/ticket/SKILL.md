---
user-invocable: false
disable-model-invocation: true
---

# ticket.json — Task Requirements

Stores the task requirements sourced from JIRA, plain text, or a sketch.

## Format

```json
{
    "key": "PROJ-1234",
    "projectName": "my-project",
    "summary": "Short description of the task",
    "description": "Full task description with all details",
    "parentKey": "PROJ-1000",
    "url": "https://yoursite.atlassian.net/browse/PROJ-1234"
}
```

- `parentKey` is optional and may be `null`
- `url` is the browse URL for the Jira ticket, constructed from the API response

Immutable once created.
