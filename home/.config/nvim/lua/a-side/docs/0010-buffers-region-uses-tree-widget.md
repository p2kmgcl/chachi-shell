# ADR 0010: Buffers region renders through the shared tree widget

**Status:** Accepted
**Date:** 2026-05-26

## Context

ADR 0008 introduced the shared tree widget at `lua/a-side/ui/tree/` with two consumers: Explorer (filesystem tree) and Git (paths from `git status --short`). The Buffers region stayed as a flat list — one line per `buflisted` non-special buffer, with a `● ` gutter for `vim.bo.modified`.

Buffer names are paths. Grouping them by parent directory under `vim.fn.getcwd()` produces a tree that uses the same visual language as the other two regions, picks up the widget's chain-flattening for free (an isolated open buffer at `src/foo/bar.lua` collapses into a single intermediate row), and removes the last place in a-side that renders structured path data as a flat list.

The trigger is consistency, not a missing feature. Buffers as a flat list is functional today; switching it to the shared widget is justified by the architectural payoff (one rendering path for all three regions, one extension point for future tree-shaped regions) plus a few user-visible wins (nesting, chain-flattening, icons).

## Decision

**The Buffers region renders through `ui/tree`. The tree is a path tree rooted at `vim.fn.getcwd()`. In-cwd buffers nest by their relative path. Out-of-cwd buffers and `[No Name]` buffers appear as direct children of the root, pinned to the bottom.**

### Tree shape: path tree rooted at cwd, not a flat tree

A "flat tree" (root + leaves only, no intermediate directories) was considered and rejected. It would dress the existing list in tree chrome without earning the widget's central capability — hierarchical grouping. A path tree mirrors Explorer's anchoring, lets chain-flattening collapse single-buffer subtrees into one row, and gives `DirChanged` a natural meaning if Buffers ever needs to re-anchor (today it does not).

A semantic asymmetry with Explorer follows from this choice and is accepted: an inner directory row in the Buffers tree means "some open buffer lives below here," not "this directory exists." Collapsing it hides buffers rather than filesystem entries. Same widget, different read.

### Out-of-cwd and `[No Name]` buffers: bottom of the root

Buffers outside cwd (e.g. `/etc/hosts`, a file in `~/other-project`) and `[No Name]` buffers have no place inside a cwd-rooted subtree. They are emitted as direct children of the root, after the in-cwd subtree, sorted alphabetically by absolute path with `[No Name]` last.

A synthetic `[external]` parent node was rejected: it adds a row that does not correspond to anything real, and the bottom-pinned-flat group communicates the same "these are outside the tree" meaning without inventing a fake directory.

Hiding them outright was also rejected: a region called "Buffers" must show all listed buffers, or its name lies.

### Modification annotation: new id `buffer_modified`, not reused `worktree_modified`

The widget's annotation vocabulary in `ui/tree/annotations.lua` is fixed by ADR 0008 specifically to enforce visual consistency across regions. Buffers adds a thirteenth id: `buffer_modified` (text `●`, hl `WarningMsg`).

Reusing `worktree_modified` (text `M`) was rejected. The two states overlap often but are not the same concept: `vim.bo.modified` means "buffer has unsaved changes since last write," while `worktree_modified` means "git's worktree differs from the index." A brand-new file under cwd is `bo.modified=true` and git-untracked, not worktree_modified. Collapsing both onto `M` would make the same glyph mean two different things depending on which region you read it in, which is exactly what the fixed-vocabulary rule exists to prevent.

This is the first non-git annotation in the vocabulary. The rule from ADR 0008 — "new regions that need new annotations extend `ui/tree/annotations.lua`; they do not invent local vocabularies" — applies here unchanged. The vocabulary is fixed in location, not in scope.

### Root label: literal `'Buffers'`, not the cwd basename

Explorer's root label is `vim.fn.fnamemodify(cwd, ':t') .. '/'` because Explorer literally is the cwd tree; Git's is the branch line because Git literally is the branch's status. The Buffers tree is not literally the cwd — it is the buffer list, which happens to be displayed under a cwd-shaped scaffold. The root label communicates the region, not the scaffold.

### Producer module: sibling `regions/buffers/list.lua`

The buffer-list → parent-map transformation lives in a new sibling file `regions/buffers/list.lua`, mirroring `regions/git/paths.lua`. It is a pure function:

```lua
-- input:  bufs = { { bufnr, name, modified }, ... }, cwd
-- output: { [parent_path] = { { name, path, is_dir, annotations = {}, bufnr? }, ... }, ... }
list.parse(bufs, cwd)
```

`buffers.lua` reads `nvim_list_bufs()` and `vim.bo[b]` on `BufAdd`/`BufDelete`/`BufModifiedSet`, builds the input records, calls `list.parse`, stores the result, and calls `handle:render()`. Same shape as `git.lua` calling `paths.parse`.

Inlining the parse in `buffers.lua` was rejected for the same reason ADR 0008 separated `paths.lua` from `git.lua`: each region owns one tree-data-shaping module, and the file layout stays self-similar across regions.

### Interaction: no `<CR>` in v1

The widget binds `<CR>` only if `on_select` is passed. Buffers does not pass it in v1, matching Explorer's stance from ADR 0007 of deferring the open/switch interaction.

Switching to the focused buffer via `<CR>` is the obvious next move and is intentionally deferred. The non-trivial part is target-window selection (the sidebar window cannot host the buffer; we would need a "most recent non-aside window" lookup), and that decision is shared with Explorer's eventual file-open binding. Both regions should land that interaction together, with one shared answer to "which window does this buffer/file go into?"

### Initial expansion and sort

`initially_expanded = true`. The whole point of the region is to surface what's open; forcing the user to expand to discover their own buffers is hostile. Git uses the same default for the same reason (small dataset, user wants the full picture).

Sort within each directory: dirs first, then files, alpha within each group, case-insensitive. At the root level: in-cwd subtree first (sorted by that rule), then the out-of-cwd + `[No Name]` group pinned to the bottom.

Chain-flattening default (on, per ADR 0009) is kept. A single-buffer subtree like `src/foo/bar.lua` renders as `src/foo/` chained with `bar.lua` as the only leaf.

### Current-buffer indicator: deferred

Today's flat list does not mark the current buffer. The tree version does not either. Adding it (a `buffer_current` annotation, or auto-placing the cursor on that row on render) is a feature, not part of this refactor. Out of scope for v1; revisitable when the lack is felt.

## Consequences

**Positive:**

- All three regions now render through one widget. No region renders structured data through ad-hoc `nvim_buf_set_lines` anymore (modulo degenerate states like "not a git repo").
- Buffers picks up nesting, chain-flattening, icons, and consistent visual treatment for free.
- The annotation vocabulary gains its first non-git id, validating the "extend in place" rule from ADR 0008 with a real second axis.
- A future fourth tree-shaped region (LSP symbols, marks, jumplist) has three precedents to follow instead of two.

**Negative:**

- An inner directory row in the Buffers tree does not mean the same thing as in Explorer (it means "an open buffer lives below" not "this dir exists"). Same widget reads as two slightly different mental models depending on region. Acceptable: the alternative (flat tree) buys nothing.
- The annotation vocabulary file is now genuinely cross-domain (git + buffer states). It will keep growing with each new region's semantics. Same trade-off as ADR 0008; this ADR confirms it rather than introduces it.
- `[No Name]` and out-of-cwd buffers share a bottom-pinned group with no visual separator. If that group grows, the lack of a heading may bite. Deferred until felt.

## Alternatives considered

- **Flat tree (root + leaf-only children).** Rejected: dresses the list in tree chrome without using the widget's hierarchical grouping; no chain-flattening payoff; same data shape as today.
- **Reuse `worktree_modified` for unsaved buffers.** Rejected: conflates two distinct concepts onto one glyph, breaking the visual-consistency rule the fixed vocabulary exists to enforce.
- **Synthetic `[external]` parent node for out-of-cwd buffers.** Rejected: invents a row that corresponds to nothing real; bottom-pinned-flat group communicates "outside the tree" with less noise.
- **Hide out-of-cwd and `[No Name]` buffers.** Rejected: a region called "Buffers" must show all listed buffers.
- **Inline `list.parse` in `buffers.lua`.** Rejected: breaks the per-region-owns-one-data-module symmetry established by `regions/git/paths.lua`.
- **Bind `<CR>` to switch to the buffer.** Deferred, not rejected. Target-window selection is a shared problem with Explorer's eventual file-open binding; both regions should adopt one answer together.
- **Current-buffer indicator (annotation or cursor placement) in v1.** Deferred, not rejected. Out of scope for a refactor; revisit when the lack is felt.
