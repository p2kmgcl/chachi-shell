return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  workspace_required = true,
  root_dir = require("helpers.get-root-dir")({
    "eslint.config.ts",
    "eslint.config.cjs",
    "eslint.config.js",
    ".eslintrc",
    ".eslintrc.ts",
    ".eslintrc.cjs",
    ".eslintrc.js",
    ".eslintrc.json",
  }),
  settings = {
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = {
      enable = false,
      mode = "all",
    },
    experimental = {
      useFlatConfig = false,
    },
    format = false,
    onIgnoredFiles = "off",
    options = {},
    packageManager = nil,
    problems = {
      shortenToSingleLine = false,
    },
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location",
    },
  },
  before_init = function(_, config)
    config.settings.workspaceFolder = {
      uri = config.root_dir,
      name = vim.fn.fnamemodify(config.root_dir, ":t"),
    }

    local pnp_file = config.root_dir .. "/.pnp.cjs"
    local has_pnp = vim.loop.fs_stat(pnp_file) ~= nil
    if has_pnp then
      config.settings.nodePath = config.root_dir .. "/.yarn/sdks"
    end
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function(arg, arg2)
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
