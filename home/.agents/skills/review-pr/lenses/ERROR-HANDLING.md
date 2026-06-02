# Lens: Error Handling Quality

Your goal: assess the **logical correctness of error paths** in the changed code and its direct
callers/callees. Ask: when something goes wrong, does the code detect it, propagate it faithfully,
and leave the system in a consistent state? Poor error handling hides bugs, confuses callers, and
causes silent data corruption.

This lens is about program logic, not runtime visibility. Do not flag a correctly-handled error
solely because it lacks a log or metric.

## Scope

Changed files and their direct callers and callees (one hop).

## What qualifies

**Detection**
- Errors that are ignored, discarded, or silently converted to a zero/null/default value
- Return values that signal failure but are not checked by the caller

**Propagation**
- Errors rethrown without context, making the root cause untraceable
- Errors converted to a generic type that loses specificity useful to callers
- Error handling that catches too broadly (e.g. bare `except`, `catch (Exception e)`)

**Communication to callers**
- Error messages that don't say what went wrong or what to do about it
- Different failure modes collapsed into one undifferentiated error

**Recovery**
- Cleanup (resources, state, locks) that is skipped on error paths
- Partial success left in an inconsistent state with no rollback
- Retry or fallback logic that masks a real failure instead of surfacing it

## What does not qualify

- Error handling that is already adequate for the realistic failure modes
- Overly defensive handling of truly impossible cases
- Style differences in how errors are expressed
- Missing logs or metrics on otherwise correctly-handled errors

## Process

1. Read the diff. Trace every error path introduced or modified.
2. For each path: follow it from origin to final handler. Ask whether the error is detected,
   whether the caller gets useful information, and whether the system ends up in a consistent state.
3. Apply the priority rubric from `PRIORITIES.md` — don't assume a priority in advance.
4. Discard anything speculative or unreachable in practice.

## Output format

Return a list of findings. Each finding must include:
- File path and line number
- One-sentence description of the error handling gap
- Why it matters (one sentence)
- Priority label from `PRIORITIES.md`

If you find nothing that meets the bar, return an empty list. That is the correct answer.
