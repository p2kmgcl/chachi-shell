# minipablo

Automated JIRA ticket implementation. Takes a ticket URL, plans the work, implements it
across atomic commits, reviews each change, validates the result, and opens a pull request.

Requires `~/.config/opencode/agent.local/AGENTS.md` with repo-specific configuration
(default branch, package manager, validation commands, etc.).

## How It Works

The [orchestrator](./minipablo.md) receives a JIRA ticket URL and runs three phases:

**Setup** — The [ticket-fetcher](./ticket-fetcher.md) pulls ticket data from JIRA.
The [worktree-creator](./worktree-creator.md) creates a git worktree and installs
dependencies. The [planner](./planner.md) explores the codebase and builds a detailed
execution plan.

**Execution loop** — The [replanner](./replanner.md) reads plan state and picks the next
action. Tasks cycle through the [developer](./developer.md) (implement + commit) and
[reviewer](./reviewer.md) (verify quality). When all tasks pass review, the
[validator](./validator.md) runs a full check — if it fails, the planner restructures
and the loop continues.

**PR creation** — The [pr-comment-handler](./pr-comment-handler.md) resolves any existing
review comments, then the [pr-creator](./pr-creator.md) pushes and opens a draft PR.
After a human reviews the PR, sending `--review` triggers the
[pr-review-fetcher](./pr-review-fetcher.md) to pull feedback, re-plan, and re-enter
the execution loop.

## Flow

```
  📥 ticket URL
        │
        ▼
  🤖 ticket-fetcher ──▶ 🤖 worktree-creator ──▶ 🤖 planner ◀─┐
        ┌─────────────────────────────────────────────┘      │
        ▼                                             │      │
  🤖 replanner ◀───────────────────────────────┐      │      │
        ├── 📋 develop_task ──▶ 🤖 developer ──┤      │      │
        ├── 📋 review_task ───▶ 🤖 reviewer ───┘      │      │
        └── 📋 validate_plan ─▶ 🤖 validator ─ fail ──┘      │
                                       │                     │
                                      pass                   │
         ┌─────────────────────────────┘                     │
         ▼                                                   │
  🤖 pr-comment-handler ──▶ 🤖 pr-creator ──▶ 🏁 draft PR    │
                                                    │        │
                     🤖 pr-review-fetcher ◀── 📥 --review    │
                               │                             │
                               └─────────────────────────────┘
```

## Agent State

All state lives in `{worktree_path}/.agent-state/`. The orchestrator only tracks
`worktree_path` — agents communicate exclusively through these files.

| File | Written by | Purpose |
|---|---|---|
| `ticket.json` | worktree-creator | JIRA ticket data |
| `plan.json` | planner, replanner | Pending and completed tasks |
| `troubleshoot.json` | planner | Ticket-specific patterns and gotchas |
| `task.json` | replanner | Current action and execution log |
| `pr-review-feedback.json` | pr-review-fetcher | Latest PR review from GitHub |
| `pr-review-feedback-accepted.json` | planner | Archived feedback after processing |
| `validator-review-feedback.json` | validator | Validation failure details |
