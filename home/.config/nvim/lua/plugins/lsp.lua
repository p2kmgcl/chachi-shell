return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      denols = require("lsp.denols"),
      eslint = {},
      gopls = {},
      jsonls = {},
      lua_ls = {},
    },
  },
}
