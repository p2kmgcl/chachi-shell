-- https://github.com/bmatcuk/stylelint-lsp
-- npm i -g stylelint-lsp

return {
  cmd = { "stylelint-lsp", "--stdio" },
  workspace_required = true,
  filetypes = { "css", "less", "scss" },
  root_markers = {
    {
      ".stylelintrc",
      ".stylelintrc.mjs",
      ".stylelintrc.cjs",
      ".stylelintrc.js",
      ".stylelintrc.json",
      ".stylelintrc.yaml",
      ".stylelintrc.yml",
      "stylelint.config.mjs",
      "stylelint.config.cjs",
      "stylelint.config.js",
    },
  },
  settings = {
    stylelintplus = {
      autoFixOnSave = false,
      autoFixOnFormat = true,
      validateOnSave = true,
      validateOnType = true,
    },
  },
}
