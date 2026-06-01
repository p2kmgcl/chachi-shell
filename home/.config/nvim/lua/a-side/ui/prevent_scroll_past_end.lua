local M = {}

local tracked = {}
local autocmd_id

local function clamp_win(winid)
  if not vim.api.nvim_win_is_valid(winid) then return end
  local bufnr = vim.api.nvim_win_get_buf(winid)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  vim.api.nvim_win_call(winid, function()
    local topline = vim.fn.line("w0")
    local height = vim.api.nvim_win_get_height(winid)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local max_topline = math.max(1, line_count - height + 1)
    if topline > max_topline then
      vim.fn.winrestview({ topline = max_topline })
    end
  end)
end

function M.enable(winids)
  tracked = winids
  local win_set = {}
  for _, winid in ipairs(tracked) do
    win_set[winid] = true
  end
  if autocmd_id then
    pcall(vim.api.nvim_del_autocmd, autocmd_id)
  end
  autocmd_id = vim.api.nvim_create_autocmd("WinScrolled", {
    callback = function(args)
      local winid = tonumber(args.match)
      if winid and win_set[winid] then
        clamp_win(winid)
      end
    end,
  })
end

function M.disable()
  if autocmd_id then
    pcall(vim.api.nvim_del_autocmd, autocmd_id)
    autocmd_id = nil
  end
  tracked = {}
end

return M
