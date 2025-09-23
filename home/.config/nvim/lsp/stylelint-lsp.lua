return {
  cmd = { "stylelint-lsp", "--stdio" },
  filetypes = { "css", "less", "scss" },
  root_markers = {
    {
      ".stylelintrc",
      ".stylelintrc.js",
      ".stylelintrc.json",
      "stylelint.config.js",
      "stylelint.config.ts",
    },
    {
      "package-lock.json",
      "yarn.lock",
      ".pnp.cjs",
    },
    ".git/",
  },
  settings = {
    stylelintplus = {
      validateOnSave = true,
      validateOnType = false,
    },
  },
}
