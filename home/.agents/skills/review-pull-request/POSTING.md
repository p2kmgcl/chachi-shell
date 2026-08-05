# Posting a Pending GitHub Review

Create one pending GitHub review containing every approved inline finding, with
consistent anchors, priority badges, and concise human-readable comments.

**API.** Create one pending review through:

```text
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

Use this payload shape, with `event` absent so GitHub keeps the review pending:

```json
{
  "body": "",
  "comments": [
    {
      "path": "file.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "![P0 SECURITY](https://img.shields.io/badge/P0-SECURITY-red) Comment text"
    }
  ]
}
```

**Comments.** Include every aggregated P0–P2 finding as one inline comment in
the single payload. Use its changed-line anchor and `RIGHT` side.

**Badge.** Begin every comment with one Shields badge:

```md
![<PRIORITY> <LENS-A>・<LENS-B>](https://img.shields.io/badge/<PRIORITY>-<ENCODED-LENSES>-<COLOR>)
```

Use the priority as the label and uppercase contributing lens filename stems as
the message, joined with `・`. Encode `・` as `%E3%83%BB`, double literal dashes
inside lens names, and URL-encode remaining unsafe path characters. Use `red`
for P0, `orange` for P1, and `yellow` for P2. Keep the alt text human-readable.

**Style.** Write one short, direct, human-sounding issue per comment. State the
problem and consequence. Add a fix snippet when it materially clarifies the
action. Use periods or commas to separate sentence parts.
