local M = {}

local ns = vim.api.nvim_create_namespace("a-side-scroll-indicators")
local tracked = {} -- list of winids
local autocmd_id

local function refresh_win(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return
  end
  local bufnr = vim.api.nvim_win_get_buf(winid)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return
  end

  local topline, botline
  vim.api.nvim_win_call(winid, function()
    topline = vim.fn.line("w0")
    botline = vim.fn.line("w$")
  end)

  if topline > 1 then
    vim.api.nvim_buf_set_extmark(bufnr, ns, topline - 1, 0, {
      virt_text = { { "▲", "AsideSeparator" } },
      virt_text_pos = "right_align",
    })
  end

  if botline < line_count then
    vim.api.nvim_buf_set_extmark(bufnr, ns, botline - 1, 0, {
      virt_text = { { "▼", "AsideSeparator" } },
      virt_text_pos = "right_align",
    })
  end
end

function M.enable(winids)
  tracked = winids

  for _, winid in ipairs(tracked) do
    refresh_win(winid)
  end

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
        refresh_win(winid)
      end
    end,
  })
end

function M.disable()
  if autocmd_id then
    pcall(vim.api.nvim_del_autocmd, autocmd_id)
    autocmd_id = nil
  end
  for _, winid in ipairs(tracked) do
    if vim.api.nvim_win_is_valid(winid) then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      end
    end
  end
  tracked = {}
end

function M.refresh(winid)
  refresh_win(winid)
end

return M
