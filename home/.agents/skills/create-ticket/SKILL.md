---
name: create-ticket
description:
  Draft and create one or more Jira tickets from the conversation with explicit
  approval. Use when the user wants to capture the current discussion as Jira
  work, draft Jira tickets, or publish one or more tickets.
---

Turn the conversation into the smallest approved set of brief Jira tickets and
create exactly those tickets with the available Jira tools.

**Context.** Use the existing conversation and ask only for information needed
to draft an accurate ticket or determine its Jira project and issue type.
Default to one ticket; split when the user requests multiple tickets or the
conversation contains independently actionable work. Briefly explain an inferred
split.

**Content.** Give each ticket a concise, outcome-focused title without a
ticket-type prefix or trailing punctuation. Begin its description with one or
two brief paragraphs and no heading. When necessary, append
`## Development details` or `## Acceptance criteria` with a plain bullet list.
Omit either section when it adds no necessary information, and do not invent
implementation details.

**Routing.** Reuse the Jira project and issue type only when clear from the
conversation or connected Jira context; otherwise ask for the missing value.

**Approval.** Present the exact ticket set and routing metadata before creating
anything. Require explicit approval and return to the draft after any requested
revision. Treat approval as authorization for only the tickets shown.

**Creation.** Create the approved tickets with the available Jira tools. If Jira
access is unavailable, stop after the approved draft, state that access is
unavailable, and neither save a substitute local file nor claim success. Do not
automatically retry a failed creation because that could create duplicates.

**Completion.** Return each created ticket's title, Jira key, and link. After a
partial failure, distinguish the tickets created from those that failed.
