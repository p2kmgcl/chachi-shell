return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = require("lsp.eslint"),
      vtsls = require("lsp.vtsls"),
    },
  },
}
