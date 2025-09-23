vim.lsp.enable({
  "bash-language-server",
  "css-lsp",
  "dockerfile-language-server",
  "eslint-lsp",
  "fish-lsp",
  "gopls",
  "html-lsp",
  "json-lsp",
  "lua_ls",
  "rust-analyzer",
  "stylelint-lsp",
  "stylua",
  "tailwindcss-language-server",
  "tombi",
  "vtsls",
  "yaml-language-server",
})

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})
