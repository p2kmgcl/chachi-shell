local M = {}

M.enabled = false
local counts = {}

function M.tick(bufnr)
  if not M.enabled then return end
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then return end
  counts[bufnr] = (counts[bufnr] or 0) + 1
  local winid = vim.fn.bufwinid(bufnr)
  if winid == -1 then return end
  local bar = vim.wo[winid].winbar
  bar = bar:gsub('%s*↑%d+$', '')
  vim.wo[winid].winbar = bar .. '  ↑' .. counts[bufnr]
end

function M.reset(bufnr)
  counts[bufnr] = nil
end

return M
