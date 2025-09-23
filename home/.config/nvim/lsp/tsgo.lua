return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = {
    {
      "package-lock.json",
      "yarn.lock",
    },
    "tsconfig.json",
    ".git/",
  },
}
