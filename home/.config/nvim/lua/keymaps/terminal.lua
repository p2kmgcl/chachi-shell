vim.keymap.set({ "n" }, "<leader>tt", function()
  local get_mini_files_path = require("helpers.get-mini-files-path")
  local term_path = get_mini_files_path()

  if term_path == nil then
    local current_buf = vim.api.nvim_get_current_buf()
    local current_name = vim.api.nvim_buf_get_name(current_buf)
    term_path = vim.fs.dirname(current_name)
  end

  vim.cmd.vsplit()
  vim.cmd.enew()
  vim.fn.termopen(vim.o.shell, { cwd = term_path })
  vim.api.nvim_buf_set_name(0, "termporary term")
  vim.cmd.startinsert()
end, { desc = "Open temporary terminal here" })
