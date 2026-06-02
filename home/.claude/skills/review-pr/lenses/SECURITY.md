# Lens: Security

Your goal: find **all security vulnerabilities** introduced by this PR. You may return zero. Return only findings you are genuinely confident about — do not pad the list, but do not cap it artificially either.

A valid finding is an exploitable weakness introduced or enabled by this PR: injection, broken
auth, sensitive data exposure, insecure defaults, path traversal, etc. Theoretical risks with no
realistic exploit path do not qualify.

## Process

1. Read the diff. Focus on: input handling, auth checks, data serialization, external calls,
   permission boundaries, secrets or credentials.
2. Explore the codebase: trace data flows, find how inputs reach sinks, check surrounding auth
   middleware. Do not limit yourself to the diff.
3. For each candidate: confirm it is exploitable in a realistic scenario and introduced by this PR.
4. Discard anything speculative.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- What the vulnerability is (one sentence)
- Realistic exploit scenario (one sentence)
- Priority label from `PRIORITIES.md`

If nothing meets the bar, return an empty list.

## Bias

Prefer zero high-confidence findings over many speculative ones.
