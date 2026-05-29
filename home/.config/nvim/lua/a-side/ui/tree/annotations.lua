local M = {}

local DEFS = {
  { id = 'index_added',         text = '', hl = 'DiffAdd' },
  { id = 'index_modified',      text = '', hl = 'DiffChange' },
  { id = 'index_deleted',       text = '', hl = 'DiffDelete' },
  { id = 'index_renamed',       text = '󰆾', hl = 'DiffChange' },
  { id = 'index_copied',        text = '', hl = 'DiffChange' },
  { id = 'index_typechange',    text = '', hl = 'DiffChange' },
  { id = 'worktree_modified',   text = '', hl = 'WarningMsg' },
  { id = 'worktree_deleted',    text = '', hl = 'ErrorMsg' },
  { id = 'worktree_typechange', text = '', hl = 'WarningMsg' },
  { id = 'untracked',           text = '', hl = 'Comment' },
  { id = 'ignored',             text = '', hl = 'Comment' },
  { id = 'conflicted',          text = '󰒨', hl = 'DiffText' },
  { id = 'buffer_modified',     text = '', hl = 'WarningMsg' },
  { id = 'clipboard_cut',       text = '', hl = 'Comment' },
  { id = 'clipboard_copy',      text = '', hl = 'Special' },
}

local by_id = {}
for i, d in ipairs(DEFS) do
  by_id[d.id] = { order = i, text = d.text, hl = d.hl }
end

function M.lookup(id) return by_id[id] end

return M
