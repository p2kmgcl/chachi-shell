# Editorial Gate

Lens output is candidate material, not review output. The main agent owns the senior-reviewer
judgment pass that decides what belongs in the pending review.

## Terms

- **Candidate finding**: a concern returned by one or more lenses.
- **Kept finding**: a candidate that survives deduplication and the editorial gate.
- **Discarded finding**: a candidate that is low-signal, duplicate, speculative, not actionable, or
  otherwise not worth reviewer attention. Discard silently by default.
- **Inline finding**: a kept finding that maps cleanly to one changed line where an inline comment
  helps the author fix it.
- **Review-body finding**: a kept finding that is relevant but cross-cutting, conceptual, multi-file,
  architectural, or not best tied to one line.

Treat all lenses equally. Side-quest lenses are not automatically lower priority or less relevant.

## Order Of Operations

1. Collect candidates from every lens.
2. Drop only obviously invalid candidates.
3. Deduplicate and merge candidates that describe the same underlying issue.
4. Reassess the merged priority after deduplication.
5. Apply the keep criteria below.
6. Place each kept finding as either inline or review-body.

Deduplication can raise priority when multiple candidates show broader impact, systemic risk, or
repeated reachable failures. Count alone is not enough; the merged consequence must be stronger.

## Keep Criteria

Keep a candidate only if all of these are true:

1. It is introduced by this PR, made worse by this PR, or made newly actionable because this PR
   touches the relevant area.
2. It is specific enough that the author can act on it without a long back-and-forth.
3. It has a concrete consequence: correctness, security, reliability, operability, maintainability,
   test confidence, API compatibility, or documentation accuracy/discoverability.
4. It is not merely preference, style, speculative future work, or "could be cleaner."
5. It is not already covered by another kept finding, an existing review thread, or failing CI.

## Placement

Use inline comments for findings that correspond to a single changed line or a clear root-cause
line. Use the review body for findings that span multiple lines/files, describe a broader design or
contract issue, or would be misleading if forced onto one line.

For multi-location findings:

- If one location is the clearest root cause, place one inline comment there and mention related
  locations briefly.
- If no single line is the root cause, place the finding in the review body with concise file
  references.
- Do not create multiple inline comments for the same underlying issue unless each location needs a
  distinct fix.

After the gate, post every kept finding to the pending review after user confirmation. Priority
labels communicate severity; they do not decide whether a kept finding is posted.
