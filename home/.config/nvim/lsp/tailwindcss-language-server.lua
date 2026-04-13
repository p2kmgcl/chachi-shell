-- https://github.com/tailwindlabs/tailwindcss-intellisense
-- npm install -g @tailwindcss/language-server

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "astro",
    "clojure",
    "css",
    "elixir",
    "eruby",
    "haml",
    "handlebars",
    "heex",
    "html",
    "htmlangular",
    "htmldjango",
    "javascript",
    "javascriptreact",
    "less",
    "liquid",
    "markdown",
    "php",
    "rescript",
    "sass",
    "scss",
    "stylus",
    "svelte",
    "twig",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
      includeLanguages = {
        eelixir = "html-eex",
        elixir = "phoenix-heex",
        eruby = "erb",
        heex = "phoenix-heex",
        htmlangular = "html",
        templ = "html",
      },
    },
  },
  before_init = function(_, config)
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  workspace_required = true,
  root_dir = require("helpers.get-root-dir")({
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
  }),
}
