-- https://github.com/microsoft/typescript-go
-- npm install @typescript/native-preview

local function get_tsgo_cmd()
  local tsgo_path = ""
  if vim.fn.isdirectory("./.yarn/sdks/typescript-go/lib/") ~= 0 then
    tsgo_path = "./.yarn/sdks/typescript-go/lib/"
  end

  return {
    tsgo_path .. "tsgo",
    "--lsp",
    "--stdio",
  }
end

return {
  cmd = get_tsgo_cmd(),
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
    "package.json",
    ".git/",
  },
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
        autoImportSpecifierExcludeRegexes = { "packages/", "^packages" },
      },
      tsserver = {
        useSyntaxServer = "auto",
        maxTsServerMemory = 1024 * 24,
        nodePath = "node",
        watchOptions = {
          excludeDirectories = { "**/node_modules", "**/.yarn", "**/.sarif" },
          excludeFiles = { ".pnp.cjs" },
        },
      },
    },
  }
}
