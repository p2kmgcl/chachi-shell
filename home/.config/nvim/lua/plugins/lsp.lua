return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      lua_ls = {},
      gopls = {},
      jsonls = {},
      marksman = {},
      taplo = {},
      ts_ls = false,
      vtsls = false,
      tsserver = false,
      eslint = require("lsp.eslint"),
      denols = require("lsp.denols"),
    },
  },
}
