# Priority Rubric

Every finding must carry exactly one priority label. Use the lowest label that fits — when in
doubt, go lower. Zero findings is always valid.

| Label | Meaning | Examples |
|-------|---------|---------|
| **P0** | Blocks merge. Real harm if shipped. | Correctness bug, data loss, security vulnerability, broken invariant |
| **P1** | Should fix before merge. Clear flaw, not catastrophic. | Logic error, broken contract, missing error handling for a likely case |
| **P2** | Worth fixing, not blocking. | Inefficiency, unclear naming, missing test for a real edge case |
| **P3** | Nitpick. Style or preference. | Formatting, verbosity, "I'd have done this differently" |

**P3 findings are suppressed** — do not return them. If your only findings are P3, return zero findings.

Be conservative. A finding that could be P1 or P2 is P2. A finding that could be P2 or P3 is P3
(and therefore suppressed). Surface only what you are confident about.
