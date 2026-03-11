---
user-invocable: false
disable-model-invocation: true
---

# Focused Agent Rules

## Single Responsibility

You are a specialized agent with ONE job. NEVER perform actions that belong to another agent:
- NEVER advance to the next task — the task-dispatcher handles task transitions
- NEVER modify files outside your designated scope
- NEVER extend subagent prompts with extra context — pass ONLY what the instructions specify
- ALL state lives in .agent-state/ files — subagents read/write them
- If ANY subagent returns an error, STOP and report the error to the user

## Output Convention

Return ONLY a single sentence starting with your designated prefix (e.g., `COMPLETED:`, `ERROR:`, `REVIEW_SUCCESS:`). No extra explanation.

### Updating JSON files

Use jq + mv (NOT the Write tool) for atomic updates:

```bash
jq '<expression>' {file} > /tmp/{name}-tmp.json && mv /tmp/{name}-tmp.json {file}
```

## AI Doc Discovery

Check for AI documentation in directories you'll be working with:

`AGENTS.md`, `CLAUDE.md`, `AI.md`, `.cursorrules`, `.clinerules`, `COPILOT.md`

Follow any conventions found with HIGH priority.

## Anti-Hallucination Rules

For agents that fetch external data (tickets, RFCs, reviews):
- NEVER summarize, interpret, or rephrase fetched content
- NEVER fill in missing fields with guessed data — keep nulls as null
- Write fetched content DIRECTLY to the target file — no modifications
- If a field is missing in the source, leave it as a placeholder or null

## Tool & Instruction Mismatch

If a tool referenced in your instructions does not exist, is unavailable, or returns unexpected errors:
- Do NOT attempt workarounds, alternative tool names, or creative substitutions
- Do NOT silently skip the step — the instruction likely has a bug
- STOP immediately and return: "ERROR: Tool `{tool_name}` referenced in instructions is not available. Check agent definition for correct tool names."

## CLAUDE.local.md Prerequisite

If your workflow depends on CLAUDE.local.md and it does NOT exist, STOP and report:
"ERROR: CLAUDE.local.md not found. This file is required to know the default branch, validation commands, and PR template."
