-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/cssls.lua

return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  init_options = { provideFormatter = true },
  root_markers = {
    "stylelint.config.js",
    "package-lock.json",
    "yarn.lock",
    ".pnp.cjs",
    ".git/",
  },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
