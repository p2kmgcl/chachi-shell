vim.opt.runtimepath:prepend(vim.fn.getcwd() .. "/home/.config/nvim")
vim.env.TMUX = nil
vim.o.lines = 40
vim.o.columns = 120

local view = require("a-side.view")
require("a-side.keymaps")
require("keymaps.window-management")

local function press(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
end

local function current_region()
  return vim.bo.filetype:match("^aside%-(.+)$")
end

local editor = vim.api.nvim_get_current_win()
vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn["repeat"]({ "editor line" }, 100))
view.toggle()
assert(vim.api.nvim_get_current_win() == editor, "opening a-side should keep focus in the editor")

press("<C-l>")
assert(current_region() == "buffers", "first entry should follow normal window navigation")
press("<C-j>")
assert(current_region() == "explorer", "moving within a-side should focus the adjacent region")
press("<C-h>")
vim.api.nvim_win_set_cursor(editor, { 1, 0 })
press("<C-l>")
assert(current_region() == "explorer", "returning from the editor should restore the last focused region")

press("<C-j>")
assert(current_region() == "git", "moving within a-side should not restore the previous region")
press("<C-h>")
vim.api.nvim_win_set_cursor(editor, { 1, 0 })
press("<C-w>l")
assert(current_region() == "git", "standard window motions should also restore the last focused region")
press("<C-h>")
vim.api.nvim_win_set_cursor(editor, { 1, 0 })
press("i<C-l>")
assert(current_region() == "git", "insert-mode window navigation should also restore the last focused region")

for _, name in ipairs({ "buffers", "explorer", "git" }) do
  press("<C-h>")
  local mapping = vim.fn.maparg("<leader>a" .. name:sub(1, 1), "n", false, true)
  mapping.callback()
  assert(
    current_region() == name,
    "explicit focus should select " .. name .. " instead of restoring the previous region"
  )
end

view.toggle()
assert(vim.api.nvim_get_current_win() == editor, "closing a-side should return focus to the editor")
press("<C-l>")
assert(vim.api.nvim_get_current_win() == editor, "closed a-side should not redirect focus")
view.toggle()
assert(vim.api.nvim_get_current_win() == editor, "reopening a-side should keep focus in the editor")
press("<C-l>")
assert(current_region() == "git", "reopening a-side should preserve the last focused region")
view.toggle()
