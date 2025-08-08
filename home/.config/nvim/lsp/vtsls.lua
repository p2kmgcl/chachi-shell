local language_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = false },
    parameterNames = { enabled = false },
    enumMemberValues = false,
    parameterTypes = false,
    propertyDeclarationTypes = false,
    variableTypes = false,
    includeInlayParameterNameHints = "none",
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = false,
    includeInlayVariableTypeHints = false,
    includeInlayPropertyDeclarationTypeHints = false,
    includeInlayFunctionLikeReturnTypeHints = false,
    includeInlayEnumMemberValueHints = false,
  },
  tsserver = {
    maxTsServerMemory = 40960,
  },
}

local function get_tsdk()
  local yarn_tsdk_path = "./.yarn/sdks/typescript/lib"
  local vscode_tsdk_path = "/Applications/%s/Contents/Resources/app/extensions/node_modules/typescript/lib"
  local vscode_tsdk = vscode_tsdk_path:format("Visual Studio Code.app")
  local vscode_insiders_tsdk = vscode_tsdk_path:format("Visual Studio Code - Insiders.app")

  if vim.fn.isdirectory(yarn_tsdk_path) == 1 then
    return yarn_tsdk_path
  elseif vim.fn.isdirectory(vscode_tsdk) == 1 then
    return vscode_tsdk
  elseif vim.fn.isdirectory(vscode_insiders_tsdk) == 1 then
    return vscode_insiders_tsdk
  else
    return nil
  end
end

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = require("helpers.get-root-dir")({ "yarn.lock", "package-lock.json", "tsconfig.json" }),
  settings = {
    typescript = language_settings,
    javascript = language_settings,
    vtsls = {
      typescript = { globalTsdk = get_tsdk() },
      autoUseWorkspaceTsdk = true,
      experimental = { completion = { enableServerSideFuzzyMatch = true } },
    },
  },
}
