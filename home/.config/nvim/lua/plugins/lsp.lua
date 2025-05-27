return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      eslint = require("lsp.eslint"),
      vtsls = require("lsp.vtsls"),
    },
  },
}
