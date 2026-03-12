---
user-invocable: false
disable-model-invocation: true
---

# rfc.md — RFC Specification

Stores the RFC document that serves as the primary requirements source when running in RFC mode. This is a markdown file (not JSON).

## Purpose

When present, rfc.md takes precedence over ticket.json's description as the source of requirements. It contains the detailed specification agreed upon with the user.

## Structure

### Jira ticket link
`[{issueKey}: {summary}]({ticketUrl})` — first line of the document, always present.

### Introduction (no heading)
One paragraph immediately after the ticket link. Describe what this RFC proposes and what the reader should expect. No "Summary" heading — the paragraph speaks for itself.

### Motivation
- What problem does this solve? What is the current pain point or gap?
- Who is affected (users, developers, other teams)?
- What happens if we do nothing?

### Detailed Design
- Technical approach: architecture, data flow, API changes, new components
- Key decisions and why they were made (not just what, but why)
- Edge cases and how they are handled
- Code examples or pseudocode where they clarify the design

### Impact
- What existing code, features, or workflows are affected?
- Migration steps or breaking changes (if any)
- Performance, security, or observability implications
- Dependencies on other teams or systems

### Open Questions
- Unresolved decisions that need input before or during implementation
- Each question should include context on why it matters and what the options are
- Remove questions as they get resolved (move answers into the relevant section)

### Revision History
- Bullet list of changes to the RFC, most recent first
- Format: `YYYY-MM-DD: description of change`

## Rules

- Do NOT repeat the page title as a heading in the body
- Do NOT use a "Summary" heading — the intro paragraph serves that role
- Task descriptions reference RFC sections for traceability
