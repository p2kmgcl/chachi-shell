# ADR 0007: explorer region design

**Status:** Accepted
**Date:** 2026-05-26

## Context

The explorer region was a placeholder rendering the literal string `Explorer`. It is the dominant region in the sidebar — heights are content-driven for Buffers and Git, and Explorer absorbs the remainder (ADR 0002). We now want real content: a navigable file tree rooted at the editor's current working directory.

The earlier iteration of a-side delegated this concern to neo-tree, embedded via an auto-open autocmd. That coupling has been removed (`autocmds/neo-tree-auto-open.lua` deleted). The decision in front of us is whether to re-embed a third-party explorer or build the region from the same primitives Buffers and Git use: a scratch buffer, a producer, the optional `enable`/`disable` lifecycle from ADR 0004.

The region carries non-trivial design weight: a tree state machine, an expand/collapse interaction, a live-update story, and a gitignore-aware visibility filter. None of these are obvious from the placeholder code, and several of them have multiple plausible answers. This ADR records the chosen branch through that decision tree.

## Decision

**The explorer region renders a custom, expandable file tree rooted at `vim.fn.getcwd()`. It owns per-expanded-directory libuv `fs_event` watchers, filters dirents via async `git check-ignore --stdin`, and is read-only in v1.**

### Structure: custom tree, not embedded plugin

The region is a scratch buffer written line-by-line, like Buffers and Git. No third-party explorer plugin is embedded.

Embedding (e.g. neo-tree) was rejected because the README's region contract — `bufhidden=hide`, `modifiable=false`, atomic close, content-driven width clamping — assumes the region owns its buffer's lifecycle. A plugin that wants to own its own window, buffer creation, and refresh cadence fights every one of those invariants. The architectural cost of making one region "the odd one out" is higher than the implementation cost of a focused tree renderer.

### Root: `vim.fn.getcwd()`, re-anchored on `DirChanged`

The tree is rooted at Neovim's current working directory, not at the git toplevel. `DirChanged` (already on the permitted-autocmd list in ADR 0004) re-anchors the tree: collapse all, clear caches, re-render.

Cwd was chosen over git toplevel because Explorer is a *project navigator*, not a *repo navigator*. The Git region already exists for repo-scoped state. Keeping the two regions answering different questions keeps them independent — `:cd` into a subdirectory of a repo and Explorer narrows while Git still shows the full repo.

### Shape: expandable, dirs-first, indented, icons via `mini.icons`

Folders render collapsed by default with a leading `▸`; expanded with `▾`. Files use the icon and highlight returned by `MiniIcons.get('file', name)`; directories use `MiniIcons.get('directory', name)`. The icon highlight is applied via `nvim_buf_set_extmark` after the line is written, since the buffer is `modifiable=false` between writes.

Within a directory, dirents are sorted directories-first, then alphabetically (case-folded). Mixing dirs with files (a pure alpha sort) reads as broken to anyone who has used another tree explorer; this is the conservative default.

Indentation is two spaces per depth level. The chevron and the icon together occupy a constant prefix width per depth.

Example:

```
chachi-shell/
▾  home/
    ▾  .config/
        ▸  nvim/
        package.json
▸  docs/
   README.md
```

### Title: line 1, basename, non-interactive

The first line of the buffer is the cwd basename followed by `/`. It is not part of the tree — `<Tab>` on the title line is a no-op, and the title carries no chevron or icon. Cursor can land on it; nothing else happens.

Tilde-shortened or absolute paths were rejected because width is content-driven across all three regions (ADR 0005). A long title would unilaterally widen the sidebar for cosmetic reasons. A winbar-based title was rejected because winbar adds a row that `view.lua`'s height algorithm does not account for.

### Initial state: depth-1 children, all collapsed

On first `enable(bufnr)` (and after each `DirChanged` re-anchor), the tree shows the direct children of cwd, all directories collapsed. The user expands what they need.

The alternative of opening with a fully-expanded root was rejected as it implies a separate "what to recurse into" policy — and the only correct answer in a repo is "respect gitignore", which we already do per-expand.

### Live updates: `fs_event` per expanded directory, debounced

Each currently-expanded directory has its own libuv `fs_event` watcher. Expanding a directory starts a watcher on it; collapsing stops it; `disable()` stops all of them.

Per-directory watchers were chosen over a single recursive watch because:

- On Linux, `fs_event` (via inotify) is per-directory and non-recursive by primitive. A recursive watch would mean walking the tree at start time and registering one watcher per descendant — including descendants the user has not expanded and may never expand.
- On macOS, FSEvents *is* natively recursive, but it would still fire for closed `node_modules/`, `.git/`, build outputs, etc. The signal-to-noise ratio collapses.
- Per-expanded-dir watching bounds cost to the directories the user actually opened. Collapse a tree and the cost goes away.

A trailing 100ms debounce coalesces bursts (multi-file `git checkout`, `npm install`, `cargo build`). Debounce timer is per-region, not per-watcher: any watcher firing schedules one render, the same way the git region does.

A render triggered by the watcher rescans only the affected directory's children, not the whole tree.

### Visibility: respect `.gitignore` if applicable; otherwise show all

`vim.loop.fs_scandir` lists every dirent. When the cwd is inside a git repo, the dirent list is filtered through `git check-ignore --stdin` (async, batched per directory) to remove gitignored paths. Dotfiles are shown by default — `.env`, `.github/`, `.gitignore`, etc. are normal project files. `.git/` itself is not specially hidden — `check-ignore` reports it as ignored in any standard repo, and outside a repo it does not exist.

Outside a git repo, `check-ignore` is skipped entirely and scandir results pass through.

### Async gitignore: scandir sync, `check-ignore` async, cache per directory

`fs_scandir` is a single syscall — microseconds for any practical directory — and is called synchronously when a directory is expanded or re-rendered. The result is rendered immediately, *unfiltered*, on the first sight of a directory.

In parallel, `git check-ignore --stdin` is invoked via `vim.system` with the scandir result piped in. When it returns, the filtered result is cached against the directory's path and the buffer is re-rendered. The brief flash of ignored files on first expand is the explicit cost of guaranteeing render latency.

The per-directory filtered cache is invalidated when:

- The watcher for that directory fires.
- `DirChanged` re-anchors the root (the whole cache is cleared).
- The region's `disable()` runs.

Subsequent renders of an unchanged directory use the cache and never re-shell to git.

### Read-only in v1, no `<CR>`

The v1 surface is intentionally narrow: render the tree, expand and collapse folders, refresh when the filesystem changes. No keymap for opening files. No create/rename/delete. No cut/copy/paste.

`<CR>` is deliberately unbound so that when a file-open interaction is added later, users do not have to unlearn a prior meaning. The same applies to `a`/`r`/`d`/`y`/`p` — left unclaimed for future mutation keymaps if and when those land.

This is a deliberate scope cap, not a permanent decision. Mutation actions imply confirmation prompts, error handling, LSP `workspace/didRenameFiles` / `didDeleteFiles` notifications, and a meaningful new surface area for bugs. Shipping the viewer first validates the rendering and watcher machinery against real use.

### Interaction: `<Tab>` toggles expand/collapse

`<Tab>` in normal mode, with cursor on a directory line, toggles its expanded state. On a file line or the title line, `<Tab>` is a no-op.

The keymap is bound buffer-locally inside the region's `enable(bufnr)` via `vim.keymap.set('n', '<Tab>', ..., { buffer = bufnr })`. It is not in `keymaps.lua` (which is reserved for global `<leader>a*` bindings) and not in an `ftplugin/aside-explorer.lua` file (which would split the region's wiring across two load paths).

`h`/`l` are left as normal vim motions inside the region — using them as expand/collapse was rejected because they are horizontal tactile motions; accidentally collapsing a chain of dirs while scrolling is a real annoyance.

### State preservation across re-renders

The region maintains two pieces of module-local state:

- `expanded_paths` — a set of absolute directory paths that are currently expanded.
- `cache[path]` — the filtered dirent list for each scanned directory, invalidated as described above.

On every render, the rendered line array is built top-down from `expanded_paths` + `cache`, and a parallel `row_to_path` table records the path each row maps to. Before re-render, the current cursor row's path is captured; after re-render, the cursor is restored to that path's new row, or — if the path no longer exists — to the nearest still-existing ancestor.

This is what lets a watcher-triggered re-render feel transparent: save a file, the tree refreshes, your cursor stays where you were looking.

`expanded_paths` is reset to empty on `disable()` (the sidebar closed entirely) and on `DirChanged` (root re-anchored). It persists across watcher-triggered re-renders and across explicit expand/collapse toggles. It does not persist across Neovim sessions.

### Symlinks: treated as files

Symlinked directories are not followed and not recursed into; they render as a single line with the link's name, and `<Tab>` on them is a no-op. This avoids cycle detection and the surprise of a watcher pointed at a path outside the project root.

A future iteration may follow symlinks selectively; the cost of getting that wrong (infinite expansion, watcher pointed at `/`) is high enough that the conservative default is the right v1.

### Safety limit on directory size: none

There is no cap on the number of entries displayed when a directory is expanded. The user explicitly opted into expansion by pressing `<Tab>`; if they expand `node_modules/` with 5000 entries, the buffer gets 5000 lines. Neovim handles this fine. The width clamp (ADR 0005) protects against pathological long names.

The watcher cost is one libuv handle per expanded directory regardless of how many files are inside it, so even pathological cases do not multiply watcher count.

### Internal file layout

Per the README's existing guidance and ADR 0004's precedent, the producer lives inside the region:

```
regions/explorer/
├── explorer.lua    -- region table; orchestrates the producer; pure surface to view
├── tree.lua        -- in-memory tree model: expanded_paths, row_to_path, line builder
├── scan.lua        -- fs_scandir + async check-ignore; per-directory cache
└── watcher.lua     -- fs_event lifecycle per expanded dir; debounce
```

`explorer.lua` is the only file `view.lua` requires. The three sibling files are invisible to the rest of the plugin.

### The autocmd rule, unchanged

This ADR does not relax the autocmd rule. The `fs_event` watchers are libuv mechanisms owned by a producer, not autocmds. The only autocmd the explorer region introduces, transitively via `view.lua`, is `DirChanged` — a layout/canvas-style event already permitted by ADR 0004's wording.

## Alternatives considered

### Alt 1: Embed neo-tree (or another explorer plugin) in the a-side window slot

Let a-side own the window placement but delegate buffer creation, rendering, and refresh to neo-tree.

Rejected because neo-tree owns its own buffer lifecycle, expects to be focused on open, and refreshes on its own cadence. The region contract (atomic close, hidden-on-close persistent scratch buffer, content-driven width across all three regions) presumes the region is a passive renderer into a buffer view.lua owns. Reconciling neo-tree's autonomy with that contract would mean reverse-engineering neo-tree's lifecycle hooks and patching around them. The implementation cost of a focused tree renderer is comparable, and the result is consistent with Buffers and Git.

### Alt 2: Root at git toplevel, fall back to cwd

Make Explorer repo-aware like Git, and only fall back to cwd when not in a repo.

Rejected because the two regions then answer overlapping questions. `:cd` into `home/.config/nvim/` and the Git region still shows the chachi-shell repo (correct for git) while Explorer would also still show the chachi-shell repo (less useful — the user has narrowed their focus). Letting Explorer track cwd keeps each region's scope orthogonal.

### Alt 3: Single recursive watcher on cwd

Start one `fs_event` with `recursive = true` on the root, fire a debounced re-render on any event.

Rejected on two grounds. First, `recursive = true` is unsupported on Linux's inotify backend — a recursive watcher would degrade silently to per-directory registration of every descendant at start. Second, even where recursion works (macOS), the watcher fires for events in directories the user has not expanded and may never expand (`.git/`, `node_modules/`, build outputs). Per-expanded-directory watching gives the same coverage of *visible* state at a fraction of the event volume.

### Alt 4: No live updates; refresh on focus or manual key

Bind `R` in `aside-explorer` to re-render, and re-render on `BufEnter` of the region's window. No watcher.

Rejected because it lands the region in the same staleness failure mode ADR 0004 named: the user saves a file, glances at Explorer, sees yesterday's tree, and learns not to trust the region. The watcher is no more code than the lifecycle to manage focus-based refresh.

### Alt 5: Gitignore via `git ls-files --cached --others --exclude-standard`

Run one git command at root, materialize the full set of visible paths into memory, intersect with scandir results when rendering each directory.

Rejected because `--cached` is recursive across the whole repo. For a monorepo we would materialize tens of thousands of paths to render the three folders the user opened. Per-directory `check-ignore --stdin` is incremental and bounded by what the user actually expanded.

### Alt 6: Parse `.gitignore` ourselves

Re-implement gitignore semantics in Lua: hierarchical files, `!` negation, glob syntax, `.git/info/exclude`, global excludes.

Rejected as its own project. Shelling out to `git check-ignore` is the only correct answer.

### Alt 7: Persistent expand state across Neovim sessions

Serialize `expanded_paths` to `stdpath('state')` on `disable()`; restore on `enable()`.

Rejected for v1. The README's State model is explicit that handles are session-scoped and re-opening reuses session state but starts fresh. Persistent state would be the first piece of disk-state in the plugin, with serialization, schema migration, and cross-tab/cross-session merge semantics to think through. Not a v1 blocker; trivially additive later.

### Alt 8: `<CR>` opens file in v1

Treat read-only-with-`<CR>` as the v1 surface.

Rejected because "open in which window" is a real decision (the editor window? the most recent non-aside window? a configurable target?) and that decision propagates through the file-open keymap suite (`s` split, `v` vsplit, `t` tabnew, etc.). Cleaner to defer the entire open-action surface to its own iteration than to ship one half-thought-through binding.

## Consequences

### Positive

- The region feels live: save a file, branch-switch in another terminal, `npm install` from a shell — the affected directories refresh within ~100ms, never blocking the UI, never costing anything when idle.
- Cost is proportional to use: closed folders cost zero (no watcher, no cache entry, no rendered lines). Expanding `node_modules/` is opt-in.
- The region's contract with `view.lua` is unchanged from ADR 0004: `render`, `enable`, `disable`. No new lifecycle hooks were needed.
- Cursor stays put across re-renders, which is what makes the watcher-driven refresh feel transparent rather than disruptive.
- The four-file internal layout (`explorer.lua`, `tree.lua`, `scan.lua`, `watcher.lua`) mirrors the Git region's three-file layout, so the producer pattern is now used by two regions and reads as a convention rather than a one-off.

### Negative

- The region grows from one file to four. The complexity is contained inside `regions/explorer/` and invisible to `view.lua`, but a reader scanning the folder sees more surface than in the placeholder.
- A leaked watcher (e.g. `disable` not called due to a crash mid-render) survives until process exit. Mitigated by `disable()` running unconditionally on `WinClosed` via the atomic-close autocmd. One watcher per expanded directory means a leaked-state worst case scales with how deep the user had drilled — bounded but not single-digit.
- The first render of a directory shows ignored files briefly before the async `check-ignore` patches the buffer. Visible flash; chosen explicitly for latency reasons.

### Out of scope

- **Opening files** (`<CR>`, `s`, `v`, `t`). Deferred to a follow-up iteration with its own decisions about target window selection.
- **File mutations** (create, rename, delete, copy, paste, chmod). Deferred. Requires LSP rename/delete notifications, confirmation prompts, undo semantics.
- **Search / fuzzy filter inside the tree.** Out of scope; that is a picker, not an explorer.
- **Cross-tab synchronization of expand state.** Splits are per-tab (README §Per-tab, not global); expand state is per-region-instance and currently per-session — there is one region instance shared across tabs because there is one buffer per region.
- **Following symlinked directories.** Conservative default is "treat as file"; revisit if a user need appears.
- **Configurability** (icons toggle, sort order, dotfile hiding, debounce window). Constants in their respective files; promote to a config table only when a second caller appears.
