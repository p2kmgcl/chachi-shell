---
user-invocable: true
description: Create a JIRA ticket interactively — gathers requirements through conversation, proposes the ticket, and creates it after approval
---

1. Invoke `local-rules` skill.
2. Ask the user what the ticket is about.
3. Keep asking if there are more details to discuss. Do not move forward until the user explicitly confirms the definition is complete.
4. Propose the full ticket (summary, type, description) and ask for approval.
5. If the user does not approve, go back to step 3 and continue the conversation.
6. On approval, create the ticket using Atlassian MCP tools with defaults from local rules.
7. Show the ticket key and link: `https://<cloudId>/browse/<KEY>`
