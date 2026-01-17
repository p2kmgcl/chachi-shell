vim.keymap.set({ "n" }, "<leader>tt", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_name = vim.api.nvim_buf_get_name(current_buf)
  local term_path = vim.fs.dirname(current_name)

  if term_path == nil or term_path == "" then
    term_path = vim.uv.cwd()
  end

  vim.cmd.vsplit()
  vim.cmd.enew()
  vim.fn.termopen(vim.o.shell, { cwd = term_path })
  vim.api.nvim_buf_set_name(0, "termporary term")
  vim.cmd.startinsert()
end, { desc = "Open temporary terminal here" })
