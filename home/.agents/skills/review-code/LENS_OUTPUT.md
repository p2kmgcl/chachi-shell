# Lens Output

Return `none` or one self-contained, evidence-backed line per finding in the
shared format, using the current lens filename stem as `<LENS>`:

```text
<file>:L<changed-line>: [P<n> <LENS>] <category>: <issue>. <consequence>.
```

**Anchor.** Use a changed line in the resulting version. Anchor a multi-location
finding at its clearest causal changed line and mention related paths in the
finding text.

**Content.** Make every line self-contained, specific, actionable, and supported
by the lens investigation. Include only finding lines in the response.

**Aggregation.** Preserve the highest priority and join contributing lens names
with `・` when merged findings describe the same issue.
