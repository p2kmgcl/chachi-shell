# 0013 — Region keymap contract

## Decision

All three regions (Buffers, Explorer, Git) share a unified keymap surface. The tree widget owns the navigation and file-open bindings; regions own their data-mutation bindings.

### Keymap table

| Key     | Region  | Dir node (non-root)               | File node                        | Root / line 1 |
|---------|---------|-----------------------------------|----------------------------------|---------------|
| `<Tab>` | all     | toggle expand/collapse (unchanged)| —                                | —             |
| `<CR>`  | all     | toggle expand/collapse            | `on_select(entry, 'edit')`       | no-op         |
| `<C-v>` | all     | no-op                             | `on_select(entry, 'vsplit')`     | no-op         |
| `<C-x>` | all     | no-op                             | `on_select(entry, 'hsplit')`     | no-op         |
| `<C-t>` | all     | no-op                             | `on_select(entry, 'tab')`        | no-op         |
| `S`       | git   | batch stage/unstage               | stage/unstage toggle             | no-op         |
| `D`     | buffers | close all (prompt if any unsaved) | close buffer (prompt if unsaved) | no-op         |
| `X`     | git     | discard all changes (confirm)     | discard changes (confirm)        | no-op         |

### Root line is non-focusable

Line 1 of every region buffer is the title/root label. The tree widget enforces a `CursorMoved` autocmd that moves the cursor to line 2 whenever it would land on line 1. This makes the root a passive label rather than an actionable node.

## Widget API changes

`tree.new` gains:
- `on_select(entry, action)` callback — replaces the previous `on_select(entry)` signature. `action` is one of `'edit' | 'vsplit' | 'hsplit' | 'tab'`. Only called for file nodes.
- `handle:cursor_entry()` — returns the entry under the cursor in the widget's window, or `nil`. Used by region-owned bindings (`D`, `X`, `S`) that are bound in `enable(bufnr)` rather than inside the widget.

The widget binds `<CR>`, `<C-v>`, `<C-x>`, `<C-t>` buffer-locally, branching on `is_dir`: dirs toggle expand/collapse (same logic as `<Tab>`); files call `on_select`. These bindings are only registered when `on_select` is provided.

## Stage/unstage semantics (`S` in Git)

- **File, unstaged or partially staged**: `git add <file>` — makes the index match the worktree.
- **File, fully staged**: `git restore --staged <file>` — drops staged changes back to HEAD.
- **Dir**: if any file under the dir is unstaged, `git add <dir>`; if all are staged, `git restore --staged <dir>`.
- **Partially staged file** counts as "unstaged" for toggle purposes — `S` stages it fully.

## Discard semantics (`X` in Git)

- **Modified tracked file**: `git restore --source=HEAD --staged --worktree <file>` — nukes both staged and worktree state in one command.
- **Untracked file**: deleted from disk (`vim.fn.delete`).
- **Dir**: applies the above per-file logic to every changed file under the dir.
- **Confirmation prompt** always shown, listing affected files and their states.

## Buffer delete semantics (`D` in Buffers)

- **File node, clean buffer**: `vim.cmd('bdelete ' .. bufnr)` — no prompt.
- **File node, unsaved buffer**: prompt "Buffer has unsaved changes. Delete anyway? [y/N]".
- **Dir node**: collects all listed buffers under the dir path. If any are unsaved, single combined prompt: "N buffers under `<dir>`, M unsaved — delete all? [y/N]". Deletes all on confirmation.

## Why the widget owns `<CR>` and the split combos

Keeping `<CR>`, `<C-v>`, `<C-x>`, `<C-t>` inside the widget (next to `<Tab>`) means all navigation and file-open bindings are in one place. Regions provide only the semantic callback (`on_select`) and stay as pure data pipelines. If the bindings lived in each region's `enable(bufnr)`, the same cursor-lookup and dir/file branching logic would be duplicated three times.

## Why `D` and `X` live in region `enable(bufnr)`, not in the widget

These are data-mutation operations specific to a single region: `D` calls `nvim_buf_delete`; `X` shells out to `git restore`. The widget has no dependency on buffer management or git commands, and that boundary should stay clean. Regions use `handle:cursor_entry()` to get the current node and act on it.

## Alternatives considered

- **Separate callbacks per action** (`on_select_vsplit`, `on_select_hsplit`, etc.): rejected — four nearly identical callbacks instead of one with an `action` parameter. Any new split variant (e.g. `tab`) would require a widget API change.
- **Regions own all keymaps** including `<CR>` / split combos: rejected — identical dir/file branching logic duplicated in three `enable` functions with no shared home.
- **`dd` for buffer delete**: considered, rejected — `D` is capital and deliberate; `dd` conflicts with the default vim delete-line muscle memory even in a `nofile` buffer.
- **No-op `S` and `X` on root via guard in callback**: considered — simpler but less safe. The `CursorMoved` guard that prevents landing on line 1 makes the root unreachable by design, so the callback guard is a redundant second line of defence rather than the primary mechanism.
