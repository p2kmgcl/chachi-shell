-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua

return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  workspace_required = true,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    {
      "eslint.config.ts",
      "eslint.config.cjs",
      "eslint.config.mjs",
      "eslint.config.js",
      ".eslintrc",
      ".eslintrc.ts",
      ".eslintrc.cjs",
      ".eslintrc.mjs",
      ".eslintrc.js",
      ".eslintrc.json",
    },
    {
      "package-lock.json",
      "yarn.lock",
      ".pnp.cjs",
    },
    ".git/",
  },
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
    format = true,
    onIgnoredFiles = "off",
    options = {},
    nodePath = "",
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
