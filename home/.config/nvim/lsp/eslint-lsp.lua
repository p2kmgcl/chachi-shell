local function get_node_path()
  local yarn_node_path = "./.yarn/sdks"

  if vim.fn.isdirectory(yarn_node_path) then
    return yarn_node_path
  else
    return ""
  end
end

return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "graphql" },
  root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" },
  settings = {
    validate = "on",
    packageManager = nil,
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeActionOnSave = { enable = false, mode = "all" },
    format = false,
    quiet = false,
    onIgnoredFiles = "off",
    options = {},
    rulesCustomizations = {},
    run = "onType",
    problems = { shortenToSingleLine = false },
    nodePath = get_node_path(),
    workingDirectory = { mode = "location" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(params, config)
    config.settings.workspaceFolder = {
      uri = params.rootPath,
      name = vim.fn.fnamemodify(params.rootPath, ":t"),
    }
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, params)
      vim.ui.open(params.url)
      return {}
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("LSP[eslint]: Probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("LSP[eslint]: Unable to load ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
