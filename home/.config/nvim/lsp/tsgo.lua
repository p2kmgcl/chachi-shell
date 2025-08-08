return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = require("helpers.get-root-dir")({
    "yarn.lock",
    "package-lock.json",
    "tsconfig.json",
  }),
}
