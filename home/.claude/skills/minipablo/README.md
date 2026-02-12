# Minipablo

Minipablo is an autonomous coding agent built on top of Claude Code's skill and subagent system. It takes a work item — a JIRA ticket, a plain text description, or an annotated sketch — and implements it end-to-end: planning, coding, reviewing, validating, and opening a draft PR. The human stays in the loop only for the final PR review.

Each step is handled by a specialized subagent with a single responsibility. The orchestrator ([SKILL.md](./SKILL.md)) routes between them; shared rules live in [common/SKILL.md](./common/SKILL.md).

## Nomenclature

| Term | Meaning |
|------|---------|
| **ticket** | The top-level work item (JIRA issue, text description, or sketch). Stored as `ticket.json`. |
| **task** | A single step inside the execution plan. Stored in `plan.json`, current one in `task.json`. |
| **plan** | The ordered list of tasks that implement a ticket. |
| **action** | The task-dispatcher's decision on what to do next (`develop_task`, `review_task`, etc.). |

## Pipeline

1. **Input** — user invokes `/minipablo <jira|jira-fallback|task|sketch> <arg>`
2. **Ticket creation** — a [ticket-creator](#ticket-creators) agent produces `ticket.json`
3. **Worktree setup** — [worktree-creator](../../agents/minipablo/worktree-creator.md) creates a git worktree, copies CLAUDE.local.md, and initializes it
4. **Planning** — [plan-creator](../../agents/minipablo/plan-creator.md) creates the execution plan
5. **Execution loop** (repeats until done):
   - [task-dispatcher](../../agents/minipablo/task-dispatcher.md) picks the next action
   - Depending on action:
     - `develop_task` → [task-developer](../../agents/minipablo/task-developer.md)
     - `review_task` → [task-reviewer](../../agents/minipablo/task-reviewer.md)
     - `validate_plan` → [gatekeeper](../../agents/minipablo/gatekeeper.md) (if failed → plan-creator replans)
     - `replan` → [plan-creator](../../agents/minipablo/plan-creator.md)
6. **PR creation**:
   - [pr-comment-handler](../../agents/minipablo/pr-comment-handler.md) resolves stale comments
   - [pr-creator](../../agents/minipablo/pr-creator.md) pushes and opens draft PR
7. **PR review** (optional, user sends `--review`):
   - [pr-review-fetcher](../../agents/minipablo/pr-review-fetcher.md) fetches feedback
   - [plan-creator](../../agents/minipablo/plan-creator.md) replans from feedback
   - Back to step 5

## Ticket creators

Produce a `/tmp/*.parsed.json` file with `{key, projectName, summary, description}`.

| Agent | Input | Model |
|-------|-------|-------|
| [ticket-creator--jira](../../agents/minipablo/ticket-creator--jira.md) | JIRA URL | haiku |
| [ticket-creator--jira-fallback](../../agents/minipablo/ticket-creator--jira-fallback.md) | Key, project, summary, description (manual) | haiku |
| [ticket-creator--raw](../../agents/minipablo/ticket-creator--raw.md) | Plain text description | haiku |
| [ticket-creator--sketch](../../agents/minipablo/ticket-creator--sketch.md) | PNG file path (Excalidraw export) | sonnet (vision) |

## State files

Subagents are stateless — they don't share conversation context. All coordination happens through JSON files in `{worktree_path}/.agent-state/`, a directory created alongside the worktree. Each agent reads the state it needs, does its work, and writes its output back. The orchestrator never touches these files directly (except reading `action.json`).

| File | Written by | Purpose |
|------|-----------|---------|
| `ticket.json` | plan-creator | Ticket requirements (from JIRA, text, or sketch) |
| `plan.json` | plan-creator | Execution plan with pending/completed tasks |
| `task.json` | task-dispatcher | Current task description and log |
| `troubleshoot.json` | plan-creator | Ticket-specific tips and patterns |
| `action.json` | task-dispatcher | Next action for the orchestrator |
| `pr-review-feedback.json` | pr-review-fetcher | Latest PR review from GitHub |
| `pr-review-feedback-accepted.json` | plan-creator | Archived feedback after replanning |
| `validator-review-feedback.json` | gatekeeper | Validation failure details (deleted on success) |
