return {
  "mason-org/mason.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    require("mason").setup(opts)

    local enabled_packages = {
      "bash-language-server",
      "css-lsp",
      "dockerfile-language-server",
      "eslint-lsp",
      "fish-lsp",
      "gofumpt",
      "goimports",
      "gopls",
      "html-lsp",
      "json-lsp",
      "lua-language-server",
      "prettier",
      "rust-analyzer",
      "shfmt",
      "stylelint-lsp",
      "stylua",
      "tailwindcss-language-server",
      "tombi",
      "vtsls",
      "yaml-language-server",
      "yamlfmt",
    }

    local registry = require("mason-registry")
    local all_package_names = registry.get_all_package_names()
    for _, package_name in ipairs(enabled_packages) do
      if vim.tbl_contains(all_package_names, package_name) then
        if not registry.is_installed(package_name) then
          vim.notify("Installing package " .. package_name, vim.log.levels.INFO, { title = "Mason" })
          registry.get_package(package_name):install()
        end
      else
        error("Package " .. package_name .. " is required but not found")
      end
    end
    for _, mason_name in ipairs(all_package_names) do
      if not vim.tbl_contains(enabled_packages, mason_name) and registry.is_installed(mason_name) then
        vim.notify("Uninstalling package " .. mason_name, vim.log.levels.INFO, { title = "Mason" })
        registry.get_package(mason_name):uninstall()
      end
    end
  end,
}
