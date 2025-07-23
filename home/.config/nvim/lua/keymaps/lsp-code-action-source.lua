vim.keymap.set({ "n", "x" }, "grA", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source" },
      diagnostics = {},
    },
  })
end, { desc = 'vim.lsp.buf.code_action("source")' })
