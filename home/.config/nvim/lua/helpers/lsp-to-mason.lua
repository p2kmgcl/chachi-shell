local mapping = {
  astro = "astro-language-server",
  bashls = "bash-language-server",
  biome = "biome",
  black = "black",
  clangd = "clangd",
  cssls = "css-lsp",
  denols = "deno",
  dockerls = "dockerfile-language-server",
  emmet_ls = "emmet-ls",
  eslint = "eslint-lsp",
  gopls = "gopls",
  graphql = "graphql-language-service-cli",
  helm_ls = "helm-ls",
  html = "html-lsp",
  intelephense = "intelephense",
  isort = "isort",
  jdtls = "jdtls",
  jsonls = "json-lsp",
  lua_ls = "lua-language-server",
  marksman = "marksman",
  omnisharp = "omnisharp",
  phpactor = "phpactor",
  prettier = "prettier",
  prismals = "prisma-language-server",
  pylsp = "python-lsp-server",
  pyright = "pyright",
  ruff_lsp = "ruff-lsp",
  rust_analyzer = "rust-analyzer",
  svelte = "svelte-language-server",
  stylua = "stylua",
  tailwindcss = "tailwindcss-language-server",
  taplo = "taplo",
  terraform_ls = "terraform-ls",
  ts_ls = "typescript-language-server",
  tsserver = "typescript-language-server",
  volar = "vue-language-server",
  vtsls = "vtsls",
  vuels = "vue-language-server",
  yamlls = "yaml-language-server",
  zls = "zls",
}

return function(server_name)
  local mason_package = mapping[server_name]
  if not mason_package then
    error("Unknown LSP server: " .. server_name .. ". Please add it to helpers/lsp-to-mason.lua")
  end
  return mason_package
end
