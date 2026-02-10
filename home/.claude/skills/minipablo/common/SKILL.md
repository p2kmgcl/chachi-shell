---
user-invocable: false
disable-model-invocation: true
---

# Minipablo Common Rules

## Single Responsibility

You are a specialized agent with ONE job. NEVER perform actions that belong to another agent:
- Only **task-developer** implements code changes and commits with git
- Only **plan-creator** creates plans and explores the codebase
- Only **task-dispatcher** decides the next action and picks the next task
- Only **pr-creator** creates or updates pull requests
- Only **pr-comment-handler** resolves PR review comments
- Only **gatekeeper** runs full validation suites (typecheck, lint, test)
- NEVER advance to the next task — the task-dispatcher handles task transitions
- NEVER modify files outside your designated scope

## Output Convention

Return ONLY a single sentence starting with your designated prefix (e.g., `COMPLETED:`, `ERROR:`, `REVIEW_SUCCESS:`). No extra explanation.

## Working Directory

Your CWD is the main repository root, NOT the worktree. ALWAYS use the worktree path for all file operations:
- Glob/Grep: pass `path={worktree_path}` (or a subdirectory within it)
- Read/Edit/Write: use absolute paths starting with `{worktree_path}/`
- Bash: `cd {worktree_path}` before running git or other commands

## .agent-state/ Conventions

All state lives in `{worktree_path}/.agent-state/`:

| File | Purpose |
|------|---------|
| `ticket.json` | Task requirements (from JIRA, text, or sketch) |
| `plan.json` | Execution plan (pending/completed tasks) |
| `task.json` | Current task description and log |
| `troubleshoot.json` | Ticket-specific tips and patterns |
| `action.json` | Next action for the orchestrator |
| `pr-review-feedback.json` | Latest PR review from GitHub |
| `pr-review-feedback-accepted.json` | Archived feedback after planner processes it |
| `validator-review-feedback.json` | Validation failure details |


### task.json format

```json
{
  "description": "{task-description}",
  "log": ["{action-1}", "{action-2}"]
}
```

The **task-dispatcher** creates and replaces task.json. All other agents ONLY append to the `log` array — never modify `description`.

### Updating JSON files

Use jq + mv (NOT the Write tool) for atomic updates:

```bash
jq '<expression>' {file} > /tmp/{name}-tmp.json && mv /tmp/{name}-tmp.json {file}
```

## AI Doc Discovery

Check for AI documentation in directories you'll be working with:

`AGENTS.md`, `CLAUDE.md`, `AI.md`, `.cursorrules`, `.clinerules`, `COPILOT.md`

Follow any conventions found with HIGH priority.

## Context Files

Before starting work, read the relevant `.agent-state/` files:
- `task.json` — what needs to be accomplished
- `plan.json` — full scope and task list
- `troubleshoot.json` — ticket-specific tips and patterns
