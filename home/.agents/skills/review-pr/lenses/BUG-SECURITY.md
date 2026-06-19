# Lens: Security

Find all security vulnerabilities introduced by this PR: an exploitable weakness introduced or enabled by the change — injection, broken auth, sensitive data exposure, insecure defaults, path traversal, and similar. Valid findings have a realistic exploit path. Prefer zero high-confidence findings over many speculative ones.

## Examples

`api/search.py:L23: injection: user query interpolated into raw SQL. Attacker reads any table via crafted input. [P0]`

`auth/login.js:L40: broken auth: session token compared with == instead of constant-time check. Enables timing-based token recovery. [P1]`

`config/storage.py:L8: insecure default: new bucket created world-readable. Any unauthenticated user lists uploaded files. [P0]`

## Process

1. Read the diff. Focus on: input handling, auth checks, data serialization, external calls, permission boundaries, secrets or credentials.
2. Explore the codebase: trace data flows, find how inputs reach sinks, check surrounding auth middleware.
3. For each candidate: confirm it is exploitable in a realistic scenario and introduced by this PR.
4. Apply the priority rubric from `PRIORITIES.md`.

## Boundaries

Flag only weaknesses with a realistic exploit path. Return only findings you are genuinely confident about.

If you find nothing that meets the bar, return an empty list. That is the correct answer.
