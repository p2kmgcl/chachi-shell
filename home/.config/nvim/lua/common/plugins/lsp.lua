return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", config = true },
    { "mason-org/mason-lspconfig.nvim" },
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    local flatten = require("common.helpers.flatten")
    local require_all = require("common.helpers.require-all")
    local enabled_packages = flatten(require_all("config/mason-packages.lua"))

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

    require_all('config/lsp-setup.lua')
  end,
}
