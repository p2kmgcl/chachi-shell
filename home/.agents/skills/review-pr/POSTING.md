# Posting a GitHub Review

## API call

Write the review payload to a temp file, then POST via:

```
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

Payload shape:

```json
{
  "body": "Overall summary plus any kept non-line-local findings",
  "comments": [
    { "path": "file.ts", "line": 42, "side": "RIGHT", "body": "![P0 SECURITY](https://img.shields.io/badge/P0-SECURITY-red) Comment text" }
  ]
}
```

**Omit `event`** to create a pending (draft) review. `side` must be `"RIGHT"`. `line` is the
line number in the new file. All comments must be in this single payload.

## What to include

Post every kept finding from `EDITORIAL.md` after user confirmation.

- Line-local kept findings become inline comments.
- Non-line-local kept findings go in the review body.
- Discarded findings are omitted silently.
- P3 findings are included but must be explicitly framed as optional in the comment text.

Priority labels communicate severity; they do not decide whether a kept finding is posted.

## Review body

Use the body for the overall summary and kept findings that do not belong on a single changed line.
Keep it concise and actionable.

Suggested shape:

```md
Summary: <1-2 sentences. Mention P0/P1 count or "no blocking issues" when useful.>

Important findings:
- ![P1 SIDE-QUEST-ARCHITECTURE](https://img.shields.io/badge/P1-SIDE--QUEST--ARCHITECTURE-orange) <finding>. Relevant files: `path/a.ts`, `path/b.ts`.
- ![P2 DOCS-DRIFT](https://img.shields.io/badge/P2-DOCS--DRIFT-yellow) <finding>. Relevant doc/code: `docs/x.md`, `src/y.ts`.
```

Omit `Important findings` when every kept finding is represented inline.

## Badge format

Start every inline comment and review-body finding with exactly one Markdown image badge:

```md
![<PRIORITY> <LENS-A>・<LENS-B>](https://img.shields.io/badge/<PRIORITY>-<ENCODED-LENSES>-<COLOR>)
```

- The badge label is the priority: `P0`, `P1`, `P2`, or `P3`.
- The badge message is the contributing lens list joined with `・`, with no spaces.
- Encode the badge URL path for Shields static badges:
  - encode `・` as `%E3%83%BB`;
  - encode each literal dash in a lens name as `--` (for example, `TEST-COVERAGE` becomes
    `TEST--COVERAGE`);
  - URL-encode any other character that is unsafe in a URL path.
- Use these colors: `P0` -> `red`, `P1` -> `orange`, `P2` -> `yellow`, `P3` -> `lightgrey`.
- The Markdown alt text should be human-readable and unencoded, for example
  `P0 SECURITY・TEST-COVERAGE`.

## Comment style

- Prefix every comment with the single Shields badge described above. Do not use raw bracket tags
  such as `[P0][LENS-NAME]`.
- The lens name is the uppercase filename stem of the lens file (e.g. `SECURITY`, `TEST-COVERAGE`).
- Short, direct, human-sounding. No em dashes.
- One issue per comment — do not bundle multiple concerns.
- Skip the snippet if the fix is obvious from context. Include one only when it clarifies the fix.
- Do not comment on pre-existing code not touched by the PR.
- Do not explain what the code does — only what's wrong and why it matters.
