# Lens Output Format

Your entire response is a findings list and nothing else. The parent agent already knows
what the PR does, why it exists, and how your lens works — it invoked you. It needs only the
findings you discovered. Anything else is noise it must strip out.

Return **one line per finding**, in the format shown in your lens's examples:

```
<file>:L<line>: <category>: <what's wrong>. <consequence>. [P<n>]
```

If nothing qualifies, return the single word: `none`

## Do NOT include

- No preamble, sign-off, or "Here are the findings".
- No summary of what the PR does or restating its description.
- No description of your process, what you searched, or files you read.
- No explanation of your lens or its bar.
- No counts, headers, grouping, severity sections, or markdown beyond the finding lines.
- No reasoning or justification beyond the `<consequence>` clause already in each line.
- No commentary when you find nothing — just `none`.

Each finding line must stand on its own. If a fact isn't part of the finding, drop it.

## Expected output

With findings:
```
api/users.py:L14: removed: field "email" dropped from UserResponse. All callers expecting it will break. [P0]
routes/orders.js:L88: type change: orderId changed from int to string. Callers doing arithmetic on it will silently misbehave. [P1]
```

Without findings:
```
none
```
