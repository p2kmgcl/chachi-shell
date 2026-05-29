# ADR 0008: shared tree widget for Explorer and Git regions

**Status:** Accepted
**Date:** 2026-05-26

## Context

ADR 0007 introduced a custom expandable file tree for the Explorer region. The Git region, in parallel, has been rendering the flat output of `git status --short --branch` directly into its buffer. The two regions answer different questions but share a visual idiom that is about to diverge unnecessarily: a rooted, indented, expandable list of paths.

The trigger for revisiting this is a desire to render Git's output as a tree too — grouping dirty paths under their directory ancestors instead of presenting a flat list. A naive copy of `regions/explorer/tree.lua` into `regions/git/` would duplicate non-trivial logic (chevron rendering, depth indentation, icon resolution, cursor-by-path restoration, expand-state management, `<Tab>` interaction) and lock the two regions into drifting independently.

This ADR records the decision to extract the tree as a reusable widget rather than duplicate or generalise in place.

## Decision

**Extract the tree renderer plus its expand/collapse interaction into a shared UI widget at `lua/a-side/ui/tree/`. Both Explorer and Git regions consume it as instances. The widget owns all visuals (chevrons, indentation, icons, annotations); regions own their data pipelines.**

### Reuse boundary: the widget, not the data layer

The reuse is the widget alone. Explorer's `scan.lua` (filesystem listing + async `git check-ignore` filter) stays in `regions/explorer/`. Git gets a new `regions/git/paths.lua` that parses `git status --short` lines into a tree-shaped path map.

A shared data-source abstraction was rejected. Explorer's pipeline is async fs + gitignore; Git's is a sync parse of a process's stdout. Two callers with shapes this different do not justify a common interface — the abstraction would either be a thin wrapper around `function() -> entries` (no real value) or a leaky compromise. The widget is the line at which reuse pays for itself.

### Tree source data

Git's tree is built from `git status` paths, not from a filtered filesystem scan. A filtered scan was rejected because deleted files do not exist on disk: an `fs scan ∩ git status` view cannot show them, which is a fundamental capability gap for a git surface. Building directly from `git status` output also avoids redundant filesystem work and naturally handles renames.

### Widget shape: instance factory, pull-based

`tree.new(opts) -> handle`. Each region constructs its own handle in `enable(bufnr)` and destroys it in `disable()`. The handle owns the expand map, the `<Tab>` keymap, the cursor-by-path restoration logic, and the rendering lifecycle.

Data flows pull-based: the widget calls a region-supplied `get_children(path)` during render. Returning `nil` means "not loaded yet"; the region calls `handle:render()` again when data arrives. This matches Explorer's existing async-scan flow exactly and costs Git nothing (its `get_children` is a synchronous lookup into an in-memory map).

A push model (`handle:set_data(tree)`) was rejected because it would force Explorer to materialise its lazily-loaded cache into a complete structure on every change — backwards from how its data actually arrives.

A module-level singleton with per-bufnr state was rejected in favour of an instance factory because the region/widget boundary is clearer when each region holds its own handle and calls `:destroy()` in `disable()`. No `{ [bufnr] = state }` table inside the widget.

### Visual authority: widget owns visuals, regions own semantics

The widget owns:

- Chevron (`▸`/`▾`/`  `) and indentation (two spaces per depth).
- Root line rendering (region provides the label string; widget places it).
- Icon resolution via `mini.icons`.
- Annotation rendering (the `M`/`A`/`??`/etc. flags for Git).

Regions own:

- The data (path entries with semantic metadata).
- When to call `handle:render()` (in response to fs watchers, git watchers, etc.).

Regions providing pre-resolved icons in their entries was rejected: the widget then duplicates plugin-coupling logic across regions and risks inconsistent icon styles between Explorer and Git. The widget is the visual authority.

### Annotation vocabulary: fixed in the widget

Entries carry `annotations = { id, id, ... }`, where each `id` is drawn from a fixed vocabulary defined in `ui/tree/annotations.lua`. The widget maps each id to a `{ text, hl }` pair and renders all of an entry's annotations in a fixed order after the name.

Multiple annotations per entry are needed because git short-status has two columns: a file can be simultaneously modified in the index and the worktree (`MM`), or added in the index and modified in the worktree (`AM`). Collapsing this to a single id loses information. The initial vocabulary therefore uses orthogonal axes — `index_modified`, `worktree_modified`, `index_added`, `worktree_deleted`, `untracked`, `renamed`, `conflicted`, etc. — and `regions/git/paths.lua` maps each `XY` code to one or two ids.

A per-region annotation map passed at construction time was rejected. Keeping the vocabulary inside the widget enforces visual consistency across regions: if a future region wants to show "modified," it uses the same id and gets the same glyph and highlight as Git. New regions that need new annotations extend `ui/tree/annotations.lua`; they do not invent local vocabularies.

### Construction API

```lua
local handle = require('a-side.ui.tree.tree').new({
  bufnr,                              -- required
  root_path,                          -- required
  root_label,                         -- required: widget does not default it
  get_children = function(path) end,  -- required
  initially_expanded = false,         -- optional, default false
  on_expand   = function(path) end,   -- optional
  on_collapse = function(path) end,   -- optional
  on_select   = function(entry) end,  -- optional; bound to <CR> if present
  on_render   = function() end,       -- optional; runs after every render
})
```

Handle methods: `:render()`, `:expand(path)`, `:collapse(path)`, `:destroy()`.

Entry shape returned by `get_children(path)`:

```lua
{ name, path, is_dir, annotations = {} }
```

`root_label` is required, not defaulted. Explorer passes `vim.fn.fnamemodify(root, ':t')`; Git passes its branch line (`## master...origin/master`). Forcing the region to be explicit avoids a "looks reasonable but wrong for me" default.

The widget never references `a-side.view`. Width/height recompute happens via the region-supplied `on_render` callback, which is the natural place for the region to call `view.resize(name)`. Pairing render with resize at construction time makes it impossible to forget.

`on_expand`/`on_collapse` are emitted from `<Tab>` so regions can react to interaction without owning the keymap. Explorer's `on_expand` triggers `scan_dir(path)`; its `on_collapse` stops the per-dir fs watcher and clears the cache.

### File layout

```
lua/a-side/
├── ui/
│   └── tree/
│       ├── tree.lua         -- public API; new(), handle methods, keymaps
│       ├── render.lua       -- pure: state → lines + highlights + entries
│       ├── annotations.lua  -- fixed id → {text, hl}
│       └── icons.lua        -- mini.icons wrapper
├── regions/
│   ├── explorer/
│   │   ├── explorer.lua     -- uses ui.tree; get_children from scan
│   │   ├── scan.lua         -- unchanged
│   │   └── watcher.lua      -- unchanged
│   └── git/
│       ├── git.lua          -- uses ui.tree; get_children from parsed status
│       ├── status.lua       -- unchanged (still produces flat path list)
│       ├── paths.lua        -- NEW: parses `git status --short` into tree map
│       └── watcher.lua      -- unchanged
```

`regions/explorer/tree.lua` is deleted; its logic moves into `ui/tree/render.lua` and the surrounding handle.

The barrel naming convention (`ui/tree/tree.lua`, not `ui/tree/init.lua`) follows the same rule used by `a-side/a-side.lua` and the region modules.

### Initial expand state

`initially_expanded` is a single global boolean, not a per-path predicate. The widget seeds the expand map with this default the first time it encounters each new directory path; user `<Tab>` toggles win thereafter.

Explorer constructs with `initially_expanded = false` (only the root expanded, current behaviour). Git constructs with `initially_expanded = true` — its dataset is small (typically <50 paths) and the user wants the full picture without interaction.

A per-path predicate was rejected: no concrete second use case justifies the API surface.

### Not-a-repo fallback (Git region)

When `git rev-parse` fails, the Git region does not construct a tree handle at all. It writes the single line "not a git repo" directly to its buffer and calls `view.resize('git')`. The tree widget is for trees; degenerate states are the region's problem.

## Consequences

**Positive:**

- One place to fix tree-rendering bugs, change indentation, add icons, or extend annotation vocabulary.
- New tree-shaped regions become cheap. (Hypothetical: an LSP-symbols region. The cost is `get_children` plus possibly new annotation ids.)
- Region modules shrink. Explorer in particular loses its rendering, expand-state, and cursor-restore code.
- Visual consistency between Explorer and Git is now structurally enforced, not maintained by convention.

**Negative:**

- The annotation vocabulary in `ui/tree/annotations.lua` couples the widget to the union of all consumers' semantic needs. As new regions land, this file grows. Acceptable: the alternative (per-region maps) loses cross-region consistency, which is the point of the shared widget.
- `paths.lua` has to handle the long tail of `git status --short` codes (renames with `->`, untracked directories shown as `dir/`, conflicted states). This is fiddly enough to have its own file but is a one-time cost.
- Explorer's behaviour is preserved, but every line of its rendering path moves; a regression window exists during the refactor.

## Alternatives considered

- **Decorate Explorer with git status instead.** Make Explorer git-aware (showing `M`/`A` flags inline in the file tree) and either drop the Git region or shrink it to a branch line. Rejected for this round: it conflates "what files exist in my project" with "what files have I changed," which are different questions for the user. Revisitable later as a layered feature on top of the widget.
- **A tree of dirty files using `regions/explorer/scan.lua` filtered by git status.** Rejected: cannot represent deleted files (Q2 above).
- **Keep `tree.lua` inside `regions/explorer/` and have Git `require` it from there.** Rejected: a sibling reaching into another sibling's folder violates the region-independence rule from the README. The widget belongs above the regions, not laterally between them.
- **A push-based widget where regions hand it a fully-built tree.** Rejected: backwards from Explorer's lazy-load reality (Q5 above).
