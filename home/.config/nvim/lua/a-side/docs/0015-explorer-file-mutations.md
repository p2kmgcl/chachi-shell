# ADR 0015: Explorer file mutation keymaps

**Status:** Accepted
**Date:** 2026-05-29

## Context

ADR 0007 shipped the Explorer region as read-only in v1, explicitly deferring file mutations (create, rename, delete, copy, move) with a note that they "require LSP rename/delete notifications, confirmation prompts, undo semantics." The reserved keymap slots (`a`/`r`/`d`/`y`/`p`) were left unclaimed pending a dedicated design iteration.

This ADR records the decisions made in that iteration.

## Decision

The Explorer region gains six mutation keymaps, all bound buffer-locally in `enable(bufnr)`. The clipboard (cut/copy) is single-node, session-scoped to a single explorer focus session, and surfaced as tree annotations.

### Keymap table

| Key | Operation | Prompt |
|-----|-----------|--------|
| `a` | Create file or directory | `vim.ui.input` — trailing `/` creates a directory, no trailing `/` creates a file |
| `r` | Rename in place | `vim.ui.input` pre-filled with the current node's **name only** (not full path) |
| `x` | Cut (mark for move) | No prompt — applies `clipboard_cut` annotation; replaces any prior clipboard entry |
| `y` | Copy (mark for copy) | No prompt — applies `clipboard_copy` annotation; replaces any prior clipboard entry |
| `p` | Paste | See paste semantics below |
| `D` | Delete | Confirmation prompt listing affected paths; hard delete, no trash |

These keymaps are bound in `explorer.lua`'s `enable(bufnr)`, not in `keymaps.lua` (which is reserved for `<leader>a*` global bindings) and not in the tree widget (which has no dependency on filesystem operations).

### Placement rule (shared by `a` and `p`)

Both create and paste use the same rule for determining the destination directory:

- **Cursor on a directory node** → operate inside that directory.
- **Cursor on a file node** → operate in the file's parent directory.

### Create (`a`)

A `vim.ui.input` prompt with an empty pre-fill appears. The entered name is joined to the destination directory. If the name ends with `/`, `vim.fn.mkdir(path, 'p')` creates a directory (and any missing ancestors). Otherwise `io.open(path, 'w'):close()` creates an empty file. After the operation, `scan_dir` is called on the destination directory and `view.resize('explorer')` is called.

### Rename (`r`)

A `vim.ui.input` prompt pre-filled with the node's current **name** (basename only, not full path). The user edits the name; the resolved destination path is `parent / new_name`. If the name is unchanged, the operation is a no-op. On completion:

1. `vim.uv.fs_rename(old_path, new_path)` executes the rename.
2. LSP notifications are sent (see below).
3. Any open buffer whose name matches `old_path` is renamed via `nvim_buf_set_name`.
4. `scan_dir` and `view.resize` are called.

### Cut and Copy (`x` / `y`)

Pressing `x` or `y` stores the current node's path in a module-local clipboard table:

```lua
clipboard = { path = ..., op = 'cut' | 'copy' }
```

The node receives a `clipboard_cut` or `clipboard_copy` annotation (new entries in `ui/tree/annotations.lua`). Pressing `x`/`y` again on any node replaces the prior clipboard entry (previous annotation cleared, new one applied).

**Clipboard is cleared on:**
- Successful paste.
- `<Esc>` (bound buffer-locally in `enable`).
- `WinLeave` of the explorer window — clipboard state is ephemeral to a single explorer focus session; switching away clears it so no "mystery annotation" persists on return.

### Paste (`p`)

Paste is only a no-op when no clipboard entry exists. Otherwise:

1. Resolve the destination directory via the placement rule above.
2. Compute the destination path: `dest_dir / basename(clipboard.path)`.
3. **Conflict check**: if the destination path already exists, show a `vim.ui.input` pre-filled with `basename_without_ext.copy.ext` (e.g. `foo.lua` → `foo.copy.lua`, `src/` → `src.copy/`). The user accepts or edits; empty input cancels.
4. Execute:
   - `op = 'copy'`: recursive copy (`vim.uv.fs_copyfile` for files; walk + mkdir + copyfile for directories).
   - `op = 'cut'`: `vim.uv.fs_rename(src, dest)` (same-filesystem fast path; cross-filesystem falls back to copy-then-delete).
5. LSP notifications sent for cut (rename semantics) — see below.
6. Clipboard cleared, annotations removed, `scan_dir` + `view.resize` called.

### Delete (`D`)

A confirmation prompt always appears before any deletion. For a **file node**, the prompt reads:

```
Delete foo.lua? [y/N]
```

For a **directory node**, the prompt lists the path and the number of contained files:

```
Delete src/ (12 files)? [y/N]
```

On confirmation, `vim.fn.delete(path, 'rf')` removes the path. Any open Neovim buffer whose name matches a deleted path is wiped (`nvim_buf_delete` with `force=true`). LSP `didDeleteFiles` notification is sent. `scan_dir` + `view.resize` called.

### LSP notifications

Sent to all active LSP clients via:

```lua
for _, client in ipairs(vim.lsp.get_clients()) do
  client.notify('workspace/willRenameFiles', { files = { ... } })
  -- execute operation --
  client.notify('workspace/didRenameFiles', { files = { ... } })
end
```

| Operation | Notifications sent |
|-----------|-------------------|
| Rename | `willRenameFiles` + `didRenameFiles` |
| Cut+paste (move) | `willRenameFiles` + `didRenameFiles` |
| Delete | `didDeleteFiles` |
| Create | `didCreateFiles` |
| Copy+paste | `didCreateFiles` (new path only; original unchanged) |

`willRenameFiles` is sent before the filesystem operation so LSP servers (e.g. `tsserver`) can compute and apply reference edits atomically.

### New annotation vocabulary entries

Two entries added to `ui/tree/annotations.lua`:

| ID | Glyph | Highlight | Meaning |
|----|-------|-----------|---------|
| `clipboard_cut` | `` (scissors) | `Comment` (dimmed) | Node is marked for move |
| `clipboard_copy` | `` (copy) | `Special` | Node is marked for copy |

## Consequences

### Positive

- The six-keymap surface (`a`/`r`/`x`/`y`/`p`/`D`) fills all the slots ADR 0007 reserved, with no conflicts against the existing widget keymaps (`<Tab>`, `<CR>`, `<C-v>`, `<C-x>`, `<C-t>`).
- The clipboard is visually grounded — annotations make the "what is in my clipboard" question answerable at a glance.
- LSP servers receive rename notifications, keeping import paths in sync for languages with file-aware servers.
- The placement rule (dir → inside, file → parent) is shared by create and paste, so there is one rule to learn, not two.
- Hard delete with mandatory confirmation mirrors the Git region's `X` (discard) contract — no new UX pattern introduced.

### Negative

- Clipboard is cleared on `WinLeave`, so copy-file → switch-to-editor → return-and-paste is not possible. This is a deliberate scope constraint, not an oversight; it avoids annotation state persisting across unrelated editing sessions.
- Cross-filesystem paste (cut across mount points) falls back to copy-then-delete, which is not atomic. A crash mid-operation leaves both copies. Acceptable for v1; a proper two-phase approach is additive.
- `willRenameFiles` is sent to all active LSP clients regardless of whether they advertise `workspace.fileOperations.willRename` capability. Clients that do not support it silently ignore the notification; no harm done, but it is a minor over-notification.

### Out of scope

- **Multi-select** — `y`/`x` operate on a single node. A visual-select mode is a separate feature.
- **Undo** — filesystem operations are not undoable via `u`. The confirmation prompt is the only safety net for delete.
- **Chmod / permissions editing** — not part of this iteration.
- **Symlink creation** — not part of this iteration.
- **Persistent clipboard across Neovim sessions** — clipboard is session-scoped and clears on WinLeave.
