local language_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
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

local function get_root_dir(bufnr, cb)
  local fname = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))

  local ts_root = vim.fs.find("tsconfig.json", { upward = true, path = fname })[1]
  local yarn_root = vim.fs.find("yarn.lock", { upward = true, path = fname })[1]
  local npm_root = vim.fs.find("package-lock.json", { upward = true, path = fname })[1]

  if yarn_root then
    cb(vim.fn.fnamemodify(yarn_root, ":h"))
  elseif npm_root then
    cb(vim.fn.fnamemodify(npm_root, ":h"))
  elseif ts_root then
    cb(vim.fn.fnamemodify(ts_root, ":h"))
  end
end

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = get_root_dir,
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
