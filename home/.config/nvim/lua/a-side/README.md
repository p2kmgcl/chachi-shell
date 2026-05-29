# a-side

A permanent right-side widget panel for Neovim. The sidebar is a single, atomic surface composed of three stacked regions, each backed by its own buffer and module.

## Purpose

`a-side` is a container for editor-navigation widgets pinned to the right of the current tab. Today it hosts three regions — `Buffers`, `Explorer`, `Git` — stacked top-to-bottom. Buffers renders a tree of open buffers grouped by their parent directory under `vim.fn.getcwd()`, with out-of-cwd and `[No Name]` buffers pinned to the bottom of the root. Explorer renders an expandable, gitignore-aware file tree rooted at `vim.fn.getcwd()`. Git renders a tree of paths reported by `git status --short --branch` for the current repo, with the branch line as the tree's root label. All three regions render through a shared tree widget at `lua/a-side/ui/tree/` (see `docs/0008-shared-tree-widget.md` and `docs/0010-buffers-region-uses-tree-widget.md`). The architecture (region contract, atomic close, content-driven dimensions, owned producers, shared visual widgets) remains the load-bearing part — content has grown to match it.

The umbrella binding `<leader>a` is reserved as the a-side prefix. `<leader>aa` toggles the whole sidebar; `<leader>ab`/`<leader>ae`/`<leader>ag` focus an individual region. Inside any region, `<CR>` opens or toggles the node under the cursor; `<C-v>`/`<C-x>`/`<C-t>` open files in splits or a new tab. The Buffers region binds `D` to close buffers; the Git region binds `S` to stage/unstage and `X` to discard changes. The Explorer region binds `a` to create, `r` to rename, `x`/`y`/`p` to cut/copy/paste, and `D` to delete. See `docs/0013-region-keymap-contract.md` and `docs/0015-explorer-file-mutations.md`.

> **Docs location:** this project does not use the `.agent-state/` convention. All a-side documentation (ADRs, design notes) lives in `home/.config/nvim/lua/a-side/docs/` so it ships with the repo.

## File layout

```
lua/a-side/
├── a-side.lua                          -- barrel: requires submodules, no logic
├── view.lua                            -- window/buffer lifecycle, atomic close
├── keymaps.lua                         -- all <leader>a* bindings live here
├── ui/
│   ├── tree/                           -- shared tree widget (ADR 0008)
│   │   ├── tree.lua                    -- public API: new(), handle methods
│   │   ├── render.lua                  -- pure: state → lines + highlights
│   │   ├── annotations.lua             -- fixed id → {text, hl} vocabulary
│   │   └── icons.lua                   -- mini.icons wrapper
│   └── scroll_indicators.lua           -- ↑/↓ overflow virtual text (ADR 0016)
├── regions/
│   ├── buffers/                        -- region: ui.tree + buffer-list parse
│   │   ├── buffers.lua
│   │   └── list.lua                    -- parses buffer list into tree map
│   ├── explorer/                       -- region: ui.tree + scan + watcher
│   │   ├── explorer.lua
│   │   ├── scan.lua
│   │   └── watcher.lua
│   └── git/                            -- region: ui.tree + status + paths + watcher
│       ├── git.lua
│       ├── status.lua
│       ├── paths.lua                   -- parses `git status --short` into tree map
│       └── watcher.lua
├── docs/                               -- ADRs and design notes
└── README.md                           -- this file
```

`init.lua` loads the plugin via `require('a-side.a-side')`. The barrel is the only public entry point.

The barrel-naming convention (`a-side/a-side.lua`, `regions/buffers/buffers.lua`) is used in place of `init.lua` so stack traces and file-pickers stay unambiguous.

## Module responsibilities

### `a-side.lua` (barrel)
Pure composition. Requires `view`, `keymaps`, and each region module. Adds no behavior of its own.

### `view.lua`
Owns:
- Three persistent scratch buffers (one per region, `bufhidden=hide`).
- Three current window handles (per tab, recreated on each open).
- The public `toggle()`, `focus(name)`, and `resize(name)` functions.
- The atomic-close invariant: any one of the three windows closing closes the other two (see Design decisions).
- The height algorithm: `Buffers` and `Git` share an 80% budget allocated proportionally to their content (floor 4 each); `Explorer` absorbs the remainder with a guaranteed floor of 4. See `docs/0011-shared-budget-for-buffers-and-git-heights.md`.
- The width algorithm: the longest line across all three region buffers drives the column width, clamped to `[MIN, MAX]` where `MIN = 30` and `MAX = floor(0.4 * vim.o.columns)`. The three regions share the column by Neovim's split semantics; view sets it once.
- The hard-coded region list: `{ buffers, explorer, git }`, in stacking order.
- The `AsideSeparator` highlight group: defined once on load, defaults to `Comment` fg. Applied via `winhighlight` on each sidebar window so the `█` horizontal split border between regions is styled without affecting other windows. See `docs/0016-region-separators-and-overflow-indicators.md`.

Does not own:
- Keybindings.
- Region content.

### `keymaps.lua`
Side-effecting on load. Binds:
- `<leader>aa` → `view.toggle()`
- `<leader>ab` → focus the Buffers region
- `<leader>ae` → focus the Explorer region
- `<leader>ag` → focus the Git region

All sidebar-related keymaps live here. Region modules do not bind keys themselves — they are pure renderers.

### `ui/scroll_indicators.lua`
Owns the `↑` / `↓` overflow virtual text shown in each region window when content extends beyond the visible area. Exports `enable(winids)`, `disable()`, and `refresh(winid)`. `view.lua` calls `enable` on open, `disable` on close, and `refresh` after every `recompute_heights()` call. A `WinScrolled` autocmd scoped to the three sidebar window IDs drives per-scroll updates. Extmarks are right-aligned (`virt_text_pos = 'right_align'`) and use the `AsideSeparator` highlight group. See `docs/0016-region-separators-and-overflow-indicators.md`.

### `regions/<name>/<name>.lua`
Each region module exports a table:

```lua
return {
  name = 'Buffers',         -- display name; also used to derive filetype
  filetype = 'aside-buffers',
  render = function(bufnr)  -- pure: writes lines into the given buffer
    ...
    -- when re-rendering after content changes, call:
    -- require('a-side.view').resize('buffers')
  end,
  -- optional lifecycle, for regions that own producers (watchers, jobs, timers):
  enable  = function(bufnr) end,  -- called by view on open
  disable = function() end,       -- called by view on close
}
```

Regions know nothing about windows, keymaps, or sibling regions. The contract to `view` is `(bufnr) -> lines` via `render`, plus optional `enable`/`disable` lifecycle hooks for regions that own internal producers. Producers (fs watchers, async jobs, timers) live as sibling files inside the region's folder (`regions/<name>/watcher.lua`, etc.) and are invisible to the rest of the plugin. See `docs/0004-git-region-live-updates-via-fs-watcher.md` for the first instance.

Region-internal keymaps (e.g. Explorer's `<Tab>` for expand/collapse) are bound buffer-locally inside the region's `enable(bufnr)` via `vim.keymap.set('n', ..., { buffer = bufnr })`. They are **not** added to `keymaps.lua`, which is reserved for the global `<leader>a*` surface.

## State model

Module-local state in `view.lua`:

| Handle           | Lifetime                                  | Validity check                  |
|------------------|-------------------------------------------|---------------------------------|
| `bufnrs[name]`   | Lazily created on first open; persists.   | `vim.api.nvim_buf_is_valid`     |
| `winids[name]`   | Created on open, cleared on close.        | `vim.api.nvim_win_is_valid`     |

One persistent buffer per region for the session. Re-opening reuses them. The atomic-close autocmd is registered once at first open and listens only for the three currently-tracked window IDs.

## Public API

```lua
require('a-side.view').toggle()
```

Plus three focus helpers consumed by `keymaps.lua`:

```lua
require('a-side.view').focus('buffers' | 'explorer' | 'git')
require('a-side.view').resize('buffers' | 'explorer' | 'git')
```

`resize` is called by a region after it rewrites its buffer; view recomputes all three heights.

One helper consumed by region `on_select` handlers:

```lua
require('a-side.view').ensure_editor_win() -- returns a valid editor winid, creating one (topleft vnew) if none exists
```

That is the entire surface. No `open`, `close`, `setup`, or config table. Add to the API only when a concrete second caller appears.

## Design decisions

These are the load-bearing choices. Changing any of them is a re-architecture, not a tweak. Reversals from earlier iterations are recorded under `docs/`.

### Explorer is an owned, custom tree — not an embedded plugin
The Explorer region is a custom expandable file tree rooted at `vim.fn.getcwd()`, re-anchored on `DirChanged`. It owns per-expanded-directory `fs_event` watchers and filters dirents via async `git check-ignore --stdin` (respecting `.gitignore` when inside a repo; showing everything otherwise; dotfiles always shown unless gitignored). `<Tab>` and `<CR>` both toggle expand/collapse on directories; `<CR>` on a file opens it (`edit`). `<C-v>`/`<C-x>`/`<C-t>` open in vertical split, horizontal split, or new tab. State (expand set, cursor-by-path, per-dir cache) is preserved across watcher-driven re-renders. Auto-reveal: while the sidebar is open, every `BufEnter` expands the ancestor directories of the current buffer and moves the cursor to its file node; buffers outside `cwd` and `[No Name]` buffers are silently ignored. File mutations: `a` creates a file or directory (trailing `/` in the name creates a directory); `r` renames in place; `x`/`y` cut/copy the node under the cursor (single-node clipboard, annotated, cleared on `<Esc>` or `WinLeave`); `p` pastes into the directory under the cursor (or its parent if the cursor is on a file), prompting on name conflict; `D` hard-deletes with a mandatory confirmation prompt. Rename, move, and delete send LSP `willRenameFiles`/`didRenameFiles`/`didDeleteFiles` notifications. See `docs/0007-explorer-region-design.md`, `docs/0012-explorer-auto-reveal.md`, `docs/0013-region-keymap-contract.md`, and `docs/0015-explorer-file-mutations.md`.

### Tree widget is shared infrastructure across all three regions
Buffers, Explorer, and Git all render through the shared widget at `lua/a-side/ui/tree/`. The widget owns visuals (chevrons, indentation, icons via `mini.icons`, annotation rendering) and the navigation keymaps (`<Tab>`, `<CR>`, `<C-v>`, `<C-x>`, `<C-t>`); regions own their data pipelines and call `handle:render()` when data changes. Line 1 of every region buffer is the title/root node — the widget enforces a `CursorMoved` guard that keeps the cursor off it. Region-specific mutation keymaps (`D` in Buffers, `S`/`X` in Git) are bound buffer-locally in `enable(bufnr)` and use `handle:cursor_entry()` to get the current node. See `docs/0013-region-keymap-contract.md`. Annotation vocabulary (e.g. `worktree_modified`, `index_added`, `untracked`, `buffer_modified`) is fixed in `ui/tree/annotations.lua` — regions pick ids from it rather than defining local mappings, which is what enforces visual consistency. `buffer_modified` is the first non-git id in the vocabulary, added because `vim.bo.modified` ("buffer has unsaved changes") and `worktree_modified` ("git's worktree differs from index") are distinct concepts that must not share a glyph. Git's tree is built directly from `git status --short` paths (parsed by `regions/git/paths.lua`); Buffers' tree is built from `nvim_list_bufs()` (parsed by `regions/buffers/list.lua`) with out-of-cwd and `[No Name]` buffers pinned to the bottom of the root. See `docs/0008-shared-tree-widget.md` and `docs/0010-buffers-region-uses-tree-widget.md`.

Region titles (root labels) are rendered in the Neovim `winbar` — pinned above the window's scrollable content area and always visible regardless of scroll position. The tree handle owns the winbar: `do_render()` and `set_root_label()` both write `vim.wo[winid].winbar`. Because the title no longer occupies line 1 of the buffer, entries start at row 1 and the `CursorMoved` guard that previously bounced the cursor off row 1 is gone. See `docs/0014-frozen-region-titles-via-winbar.md`.

The widget also flattens single-child directory chains by default: a run of dirs where each has exactly one (unannotated) dir child renders as one row `a/b/c/`. Tab toggles the whole chain as a unit. The toggle is runtime-flippable via `handle:toggle_flatten()`. See `docs/0009-tree-widget-directory-flattening.md`.

### Widget container, not passive HUD
a-side hosts named, evolvable widgets (Buffers, Explorer, Git). Earlier framing as a passive info HUD has been superseded — see `docs/0001-a-side-becomes-widget-container.md`.

### Three stacked rows, explorer-driven width, content-driven heights
The sidebar is one vertical column split into three rows.

**Heights** are content-driven. `Buffers` and `Git` share a single 80% budget of `total` (the combined height of the three a-side windows), allocated by content size:

- If `line_count(buffers) + line_count(git) ≤ budget`, each takes exactly the rows its content needs.
- Otherwise, the budget is split proportionally: `buffers_h = floor(budget * want_b / (want_b + want_g))`, `git_h = budget - buffers_h`.
- Each of the two is floored at 4 rows (stealing from the sibling if proportional scaling would drop one below 4).
- `budget = min(floor(0.8 * total), total - 4)` so `Explorer` always retains its floor of 4.

`Explorer` takes the remainder. Under budget, that is typically well above 20%; when the budget is fully consumed, it is exactly 20% of `total`. See `docs/0011-shared-budget-for-buffers-and-git-heights.md` (supersedes the per-region `floor(total/3)` cap from `docs/0002-content-driven-region-heights.md`). Floor raised from 2 to 4 in `docs/0014-frozen-region-titles-via-winbar.md`.

**Width** is content-driven across all three regions: `width = clamp(max strdisplaywidth(line) across {buffers, explorer, git} buffers and their winbar titles, MIN, MAX)`, with `MIN = 30` and `MAX = floor(0.4 * vim.o.columns)`. The three regions share the column by Neovim's vertical-split semantics; view sets width on the column once.

Width and heights both recompute on every `view.resize(name)` call, and width also recomputes on `VimResized`. Regions call `view.resize(name)` after rewriting their buffer. View owns both axes absolutely: manual `<C-w>+`/`<C-w>-`/`<C-w><`/`<C-w>>` inside the sidebar is undone on the next render. See `docs/0002-content-driven-region-heights.md`, `docs/0011-shared-budget-for-buffers-and-git-heights.md`, `docs/0003-explorer-driven-width.md`, and `docs/0005-width-driven-by-all-regions.md`.

### Atomic close via scoped `WinClosed`
The sidebar is a single thing. Closing any one of the three windows (via `:q`, `<C-w>c`, or anything else) closes the other two. This is enforced by a `WinClosed` autocmd scoped to the three tracked window IDs.

This is a narrowing of the original "never via autocmds" rule. The rule now reads: **autocmds that react to incidental user editing activity (TextChanged, `BufWritePost`, …) are forbidden; scoped autocmds that maintain a-side's own internal invariants (`WinClosed` for atomic close), react to layout/canvas changes (`VimResized` for width clamping, `DirChanged` for re-anchoring repo-aware regions), or observe state changes of a region's own data source (`BufAdd`/`BufDelete`/`BufModifiedSet` for the Buffers region, `BufEnter` for the Explorer region's auto-reveal) are allowed.** The underlying principle: observe your own data source; don't react to incidental editing activity outside it. Libuv mechanisms (`fs_event`, timers) owned by a region's producer are not autocmds and are not constrained by this rule — see `docs/0004-git-region-live-updates-via-fs-watcher.md`. Background: `docs/0001-a-side-becomes-widget-container.md`, `docs/0003-explorer-driven-width.md`, `docs/0006-buffers-region-live-updates-via-buffer-list-events.md`.

### Vertical split, not floating window
A split cooperates with `<C-w>` motions, resizes, and `winfixwidth`. A float would overlay code and require manual repositioning on terminal resize.

### Hide buffers on close, don't wipe
One persistent scratch buffer per region for the session. Re-opening is instant; any future state (cursor, scroll, content) is preserved.

### Per-tab, not global
Splits are inherently per-tab in Neovim. No `TabEnter` autocmd mirrors the sidebar across tabs.

### Auto-open on startup
a-side opens automatically on every Neovim start via a one-shot `UIEnter` autocmd registered at module load time in `view.lua`. The trigger is `UIEnter` (not `VimEnter`) because it fires after the UI is attached and safe for window creation. Opening is unconditional — no check for git repo, argument list, or session state. See `docs/0017-auto-open-on-uienter.md`.

### Focus on open: stays in editor; per-region jumps explicit
Neither auto-open nor `<leader>aa` (toggle-open) steal focus — opening the sidebar should never interrupt typing. To enter a region, use its explicit focus binding (`<leader>ab`/`<leader>ae`/`<leader>ag`) or any standard window motion (`<C-w>l`, etc.).

### Per-region filetypes
Each region's buffer gets its own filetype: `aside-buffers`, `aside-explorer`, `aside-git`. This is the hook for region-specific syntax, highlights, and autocmds — target the filetype, not the buffer name. To target "all a-side regions," match the pattern `aside-*`.

### Buffer hygiene
Each region buffer is a textbook scratch buffer:

| Option        | Value             |
|---------------|-------------------|
| `buftype`     | `nofile`          |
| `bufhidden`   | `hide`            |
| `swapfile`    | `false`           |
| `buflisted`   | `false`           |
| `modifiable`  | `false`           |
| `filetype`    | `aside-<region>`  |

Window-locals on each region window: `nonumber`, `norelativenumber`, `nowrap`, `cursorline`, `winfixwidth`.

## Extending

- **Real content for a region**: replace the placeholder `render(bufnr)` in `regions/<name>/<name>.lua`. Producers may add internal files under their own folder (`regions/buffers/sources.lua`, etc.) without touching siblings. Locking discipline: `modifiable=true`, write, `modifiable=false`.
- **Adding a region**: create `regions/<name>/<name>.lua`, add it to the region list in `view.lua`, add its focus binding to `keymaps.lua`. Three files; intentional.
- **More keymaps**: add to `keymaps.lua`. Region modules remain pure renderers.
- **Reacting to editor events**: scoped autocmds that maintain internal invariants or react to layout/canvas changes belong in `view.lua` or a new submodule required from the barrel. Autocmds that react to user editing activity (TabEnter, BufEnter, TextChanged, etc.) are still off-limits.
- **Configurability**: when the second caller for any knob appears, introduce a single config table in the barrel and thread it through `view.setup(opts)`. Not before.

## What this plugin deliberately is not

- Not a floating popup library.
- Not configurable (yet).
- Not interactive on the umbrella binding — `<leader>aa` never steals focus.
