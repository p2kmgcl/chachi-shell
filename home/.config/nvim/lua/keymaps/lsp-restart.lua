vim.keymap.set({ "n" }, "<leader>lr", function()
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.cmd('edit')
end, { desc = "Restart all LSP servers" })
