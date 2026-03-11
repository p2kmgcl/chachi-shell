---
user-invocable: false
disable-model-invocation: true
---

# rfc.md — RFC Specification

Stores the RFC document that serves as the primary requirements source when running in RFC mode. This is a markdown file (not JSON).

## Purpose

When present, rfc.md takes precedence over ticket.json's description as the source of requirements. It contains the detailed specification agreed upon with the user.

## Rules

- Task descriptions reference RFC sections for traceability
- A "Revision History" section is maintained at the bottom
