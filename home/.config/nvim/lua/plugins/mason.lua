return {
  "mason-org/mason.nvim",
  config = function(_, opts)
    local lsp_config = require("plugins.lsp")
    local lsp_to_mason = require("helpers.lsp-to-mason")
    local registry = require("mason-registry")

    -- These entries are NOT LSP servers, they are formatters, linters, etc.
    -- We will add the LSP servers below.
    local enabled_packages = {
      "gofumpt",
      "goimports",
      "stylua",
    }

    if lsp_config.opts and lsp_config.opts.servers then
      for server, config in pairs(lsp_config.opts.servers) do
        local mason_name = lsp_to_mason(server)
        if config ~= false then
          table.insert(enabled_packages, mason_name)
        end
      end
    end

    require("mason").setup(opts)

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
