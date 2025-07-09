local mapping = {
  -- Current servers
  lua_ls = "lua-language-server",
  gopls = "gopls",
  jsonls = "json-lsp",
  marksman = "marksman",
  taplo = "taplo",
  eslint = "eslint-lsp",
  denols = "deno",
  ts_ls = "typescript-language-server",
  vtsls = "vtsls",
  tsserver = "typescript-language-server",
  
  -- Common servers you might add
  rust_analyzer = "rust-analyzer",
  pyright = "pyright",
  pylsp = "python-lsp-server",
  clangd = "clangd",
  bashls = "bash-language-server",
  dockerls = "dockerfile-language-server",
  html = "html-lsp",
  cssls = "css-lsp",
  tailwindcss = "tailwindcss-language-server",
  emmet_ls = "emmet-ls",
  yamlls = "yaml-language-server",
  helm_ls = "helm-ls",
  terraform_ls = "terraform-ls",
  prismals = "prisma-language-server",
  graphql = "graphql-language-service-cli",
  svelte = "svelte-language-server",
  vuels = "vue-language-server",
  volar = "vue-language-server",
  astro = "astro-language-server",
  ruff_lsp = "ruff-lsp",
  black = "black",
  isort = "isort",
  prettier = "prettier",
  biome = "biome",
  phpactor = "phpactor",
  intelephense = "intelephense",
  jdtls = "jdtls",
  omnisharp = "omnisharp",
  zls = "zls",
}

return function(server_name)
  local mason_package = mapping[server_name]
  if not mason_package then
    error("Unknown LSP server: " .. server_name .. ". Please add it to helpers/lsp-to-mason.lua")
  end
  return mason_package
end