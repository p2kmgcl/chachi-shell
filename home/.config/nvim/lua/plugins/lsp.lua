return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      denols = require("lsp.denols"),
      eslint = require("lsp.eslint"),
      vtsls = require("lsp.vtsls"),
    },
  },
}
