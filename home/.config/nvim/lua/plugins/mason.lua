return {
  "mason-org/mason.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    require("mason").setup(opts)

    local enabled_packages = {
      "bash-language-server",
      "css-lsp",
      "dockerfile-language-server",
      "eslint_d",
      "fish-lsp",
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
    for _, mason_name in ipairs(registry.get_all_package_names()) do
      if vim.tbl_contains(enabled_packages, mason_name) then
        if not registry.is_installed(mason_name) then
          vim.notify("Installing package " .. mason_name, vim.log.levels.INFO, { title = "Mason" })
          registry.get_package(mason_name):install()
        end
      else
        if registry.is_installed(mason_name) then
          vim.notify("Uninstalling package " .. mason_name, vim.log.levels.INFO, { title = "Mason" })
          registry.get_package(mason_name):uninstall()
        end
      end
    end
  end,
}
