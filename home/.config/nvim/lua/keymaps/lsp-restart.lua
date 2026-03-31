vim.keymap.set({ "n" }, "<leader>lr", function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
  end
  vim.cmd('edit')
end, { desc = "Restart all LSP servers" })
