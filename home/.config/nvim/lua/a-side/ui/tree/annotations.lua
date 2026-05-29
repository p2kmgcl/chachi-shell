local M = {}

local DEFS = {
  { id = 'index_added',         text = '+', hl = 'DiffAdd' },
  { id = 'index_modified',      text = '•', hl = 'DiffAdd' },
  { id = 'index_deleted',       text = '⨯', hl = 'DiffAdd' },
  { id = 'index_renamed',       text = '↦', hl = 'DiffAdd' },
  { id = 'index_copied',        text = '⇔', hl = 'DiffAdd' },
  { id = 'index_typechange',    text = '⇄', hl = 'DiffAdd' },
  { id = 'worktree_modified',   text = '•', hl = 'Comment' },
  { id = 'worktree_deleted',    text = '⨯', hl = 'Comment' },
  { id = 'worktree_typechange', text = '⇆', hl = 'Comment' },
  { id = 'untracked',           text = '?', hl = 'Comment' },
  { id = 'ignored',             text = '◌', hl = 'Comment' },
  { id = 'conflicted',          text = '!', hl = 'Comment' },
  { id = 'buffer_modified',     text = '•', hl = 'Comment' },
  { id = 'clipboard_cut',       text = '📎', hl = 'Comment' },
  { id = 'clipboard_copy',      text = '📎', hl = 'Comment' },
}

local by_id = {}
for i, d in ipairs(DEFS) do
  by_id[d.id] = { order = i, text = d.text, hl = d.hl }
end

function M.lookup(id) return by_id[id] end

return M
