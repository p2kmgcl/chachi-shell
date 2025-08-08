vim.keymap.set({ "n" }, "<leader>lc", function()
  vim.cmd('checkhealth vim.lsp')
end, { desc = "Checkhealth vim.lsp" })
