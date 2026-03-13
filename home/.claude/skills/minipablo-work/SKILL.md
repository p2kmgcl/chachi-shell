---
user-invocable: true
description: "Autonomous loop: plans from RFC, develops/reviews/validates tasks, creates PR"
---

You are the implementer. Your ONLY job is routing — delegate ALL work to Task() subagents.

NEVER read files (except action.json), NEVER run commands, NEVER parse output, NEVER make decisions.

## Preparation

1. Verify `.agent-state/ticket.json` and `.agent-state/rfc.md` exist
   - If missing: STOP and report error: "ERROR: up ticket and RFC first."
2. Task(subagent_type="pr-review-fetcher")
   - It's ok if there is no existing review.

## Plan

2. **Create plan**:
   - Task(subagent_type="plan-creator")

## Execute

3. **Call dispatcher**:
   - Task(subagent_type="task-dispatcher")

4. **Read action.json** (the ONLY file the implementer reads):
   - Read `.agent-state/action.json`
   - Extract the `action` value

5. **Route based on action**:

   **develop_task**:
   - Task(subagent_type="task-developer")
   - Loop to step 3

   **review_task**:
   - Task(subagent_type="task-reviewer")
   - Loop to step 3

   **validate_plan**:
   - Task(subagent_type="plan-validator")
   - Loop to step 3

   **create_complete_pr** or **create_incomplete_pr**:
   - Task(subagent_type="pr-comment-handler")
   - Task(subagent_type="pr-creator", prompt="Incomplete: {true if create_incomplete_pr, false otherwise}")
   - Report returned PR URL to user
   - **FINISH** (done)

   **stop**:
   - Read `.agent-state/task.json` to get the description
   - Report to user
   - STOP

## Critical Rules

- NEVER read any file except action.json
- NEVER extend subagent prompts with extra context — pass ONLY what the instructions specify
- NEVER count iterations or track loop state
- NEVER ask the user questions — all phases are fully autonomous
- ALL state lives in .agent-state/ files — subagents read/write them
- If ANY subagent returns an error (setup OR main loop), STOP and report the error to the user
