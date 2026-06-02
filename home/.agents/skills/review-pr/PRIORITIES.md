# Priority Rubric

Every finding must carry exactly one priority label. Use the lowest label that fits — when in
doubt, go lower. Zero findings is always valid.

| Label | Meaning | Examples |
|-------|---------|---------|
| **P0** | Blocks merge. Real harm if shipped. | Correctness bug, data loss, security vulnerability, broken invariant |
| **P1** | Should fix before merge. Clear flaw, not catastrophic. | Logic error, broken/misleading API contract, silent wrong result, missing error handling for a likely case |
| **P2** | Worth fixing, not blocking. | Performance regression on a reachable path, observability gap that makes production failures undiagnosable, missing tests for complex branching logic, naming that actively confuses the contract, architectural pattern that blocks future changes |
| **P3** | Optional suggestion. Low-stakes, not actionable immediately. | Minor optimizations, style preferences, "consider for a follow-up", "I'd have done this differently" |

P3 findings **must be explicitly framed as optional** in the comment text. They are posted but
should never feel like requests.

Be conservative. A finding that could be P1 or P2 is P2. A finding that could be P2 or P3 is P3.
Surface only what you are confident about.
