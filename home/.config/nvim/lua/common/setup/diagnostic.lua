vim.diagnostic.config({
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_lines = false,
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  float = {
    focusable = false,
    border = "rounded",
  },
})

-- Default keymaps
-- vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- vim.keymap.set("n", "]d", vim.diagnostic.go_to_next, { desc = "Next Diagnostic" })
-- vim.keymap.set("n", "[d", vim.diagnostic.go_to_prev, { desc = "Prev Diagnostic" })
-- vim.keymap.set("n", "]D", vim.diagnostic.go_to_last, { desc = "Last Diagnostic" })
-- vim.keymap.set("n", "[D", vim.diagnostic.go_to_first, { desc = "First Diagnostic" })

-- Enable diagnostics
vim.diagnostic.enable()
