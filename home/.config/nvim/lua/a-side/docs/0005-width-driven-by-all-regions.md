# ADR 0005: width driven by all regions

**Status:** Accepted
**Date:** 2026-05-26
**Supersedes in part:** [0003 — explorer-driven sidebar width](./0003-explorer-driven-width.md)

## Context

ADR 0003 made the sidebar's width content-driven, but only from Explorer. The supporting claim was that "Buffers and Git are bounded-short by design — only Explorer ever wants to grow." That claim was load-bearing for Alt 2 ("Width = longest line across all three buffers"), which was rejected on its basis.

Real Git content breaks the claim. Branch names, dirty-path entries, commit subjects, and ahead/behind summaries all routinely exceed 30 columns. Under the ADR-0003 rule those lines are truncated even when Explorer is narrow enough that the column has room to grow — the column is artificially short because the only region permitted to push it wider has nothing long to show.

The premise that one region is special is the part that has aged badly, not the algorithm itself. Generalising the signal removes a coupling surface (`WIDTH_DRIVER = 'explorer'`) and makes the rule survive future regions without re-litigation.

## Decision

**Width is driven by the longest line across all three region buffers, recomputed on every region's `view.resize(name)` and on `VimResized`, owned absolutely by `view.lua`.**

### The algorithm

```
MIN   = 30
MAX   = floor(0.4 * vim.o.columns)
need  = max(strdisplaywidth(line) for line in buffer
            for buffer in {buffers, explorer, git})
width = clamp(need, MIN, MAX)
```

- `MIN`, `MAX`, and `strdisplaywidth` semantics carry over from ADR 0003 unchanged.
- The signal is now the max across all three buffers. Splits share width by Neovim's vertical-split semantics; view sets the column width once.

### The triggers

Width recomputes on:

1. **Any region's render** — every `view.resize(name)` recomputes both width and heights. The Explorer-only special case in `view.resize` is removed.
2. **Terminal/editor canvas resizes** — `VimResized` autocmd unchanged from ADR 0003.

This includes out-of-band Git re-renders driven by the fs-watcher (ADR 0004). Branch switches and index changes will pull the column wider or narrower without user input. Accepted: width is a function of content, and "content changed" is exactly when the function should run.

### View still owns width absolutely

Unchanged from ADR 0003. Manual `<C-w><` / `<C-w>>` inside the sidebar is undone on the next recompute.

## Alternatives considered

### Alt 1: Keep explorer-only

Status quo. Rejected: Git content exceeds 30 cols in normal use, and the artificial truncation is visible to the user with no way out short of the user-forbidden manual resize.

### Alt 2: Add Git as a second driver, leave Buffers out

Two drivers, one excluded. Rejected: Buffers will gain real content (full paths, indicators) and we will be back here. Excluding one region now buys nothing and adds a per-region-permission concept that does not need to exist.

### Alt 3: Per-region width contribution opt-in

Each region declares whether it contributes to the width signal. Rejected for the same reason as ADR 0003's Alt 3: the buffer is the source of truth. Adding a `contributes_to_width` flag is configuration looking for a problem.

## Consequences

### Positive

- Git's long lines are visible without manual resize.
- `view.lua` loses the `WIDTH_DRIVER` constant and the Explorer-only branch in `view.resize`. Width and heights now recompute together on every `resize(name)` call — symmetric, smaller surface.
- The region contract is unchanged. Regions still expose `render(bufnr)`; view still measures buffers.

### Negative

- Reverses ADR 0003's Alt-2 rejection. Future readers comparing the two ADRs need this one as the trail.
- Width can now change in response to *any* region's content change, including fs-watcher-driven Git renders. Bounded by `MIN`/`MAX`, but the surface area for "width changed without user input" is three regions wide instead of one.

### Out of scope

- Per-region width caps or contributions. Width is still one number for the whole column, computed from the unweighted max.
- Configurability of `MIN`, `MAX`, the 40% fraction, or which regions participate. Same single-set-of-constants stance as ADR 0003.
