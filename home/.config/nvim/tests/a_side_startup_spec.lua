vim.cmd("doautocmd UIEnter")

local aside_windows = 0
for _, winid in ipairs(vim.api.nvim_list_wins()) do
  local bufnr = vim.api.nvim_win_get_buf(winid)
  if vim.bo[bufnr].filetype:match("^aside%-") then
    aside_windows = aside_windows + 1
  end
end

assert(aside_windows == 0, "a-side should stay closed on startup")
