return {
  cmd = { "stylelint-lsp", "--stdio" },
  filetypes = { "css", "less", "scss" },
  root_markers = {
    ".stylelintrc",
    ".stylelintrc.js",
    ".stylelintrc.json",
    "stylelint.config.js",
  },
  settings = {
    stylelintplus = {
      validateOnSave = true,
      validateOnType = false,
    },
  },
}
