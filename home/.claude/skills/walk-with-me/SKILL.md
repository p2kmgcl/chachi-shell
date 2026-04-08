---
user-invocable: true
description: "Execute a plan interactively, pausing for user validation before each commit"
---

1. Read the active plan. Split it into the smallest possible tasks — one commit each.
   Aim for **< 50 lines changed per commit**. A large change to a single file is still too big.

   Splitting guidelines:
   - Types, implementation, and wiring are separate tasks.
   - New files MUST be scaffolded first (props/interface, empty render), then each concern
     (state, data fetching, event handling, rendering) added in its own task.
   - Refactors that touch many files should be split by area.
   - Adding a dependency goes with the first task that needs it.

2. For each task:
   a. Implement following `/write-code` standards. Run verification commands from the plan
      and fix any failures before proceeding.
      If the diff grows beyond the target size, undo all changes, split the task into
      smaller subtasks in the todo list, and restart with the first subtask.
   b. Present changes and a draft commit message. Ask the user to validate.
      If the user requests changes, apply and re-present.
      If the user edits the plan, re-read and adjust the todo list.
   c. On approval, commit following `/commit` conventions.

Never commit without explicit user approval.
