return {
  "mason-org/mason.nvim",
  opts = function()
    local lsp_config = require("plugins.lsp")
    local enabled_servers = {}

    -- Extract enabled servers from LSP config
    if lsp_config.opts and lsp_config.opts.servers then
      for server, config in pairs(lsp_config.opts.servers) do
        if config ~= false then
          table.insert(enabled_servers, server)
        end
      end
    end

    -- Map LSP server names to Mason package names
    local lsp_to_mason = require("helpers.lsp-to-mason")

    local mason_packages = {}
    for _, server in ipairs(enabled_servers) do
      local mason_name = lsp_to_mason(server)
      table.insert(mason_packages, mason_name)
    end

    -- Add additional tools
    table.insert(mason_packages, "stylua")
    table.insert(mason_packages, "gofumpt")
    table.insert(mason_packages, "goimports")

    return {
      ensure_installed = mason_packages,
    }
  end,
  config = function(_, opts)
    require("mason").setup(opts)
    -- Auto-uninstall disabled LSP servers
    local lsp_config = require("plugins.lsp")
    local disabled_servers = {}

    -- Extract disabled servers from LSP config
    if lsp_config.opts and lsp_config.opts.servers then
      for server, config in pairs(lsp_config.opts.servers) do
        if config == false then
          table.insert(disabled_servers, server)
        end
      end
    end

    -- Map LSP server names to Mason package names
    local lsp_to_mason = require("helpers.lsp-to-mason")

    local registry = require("mason-registry")
    for _, server in ipairs(disabled_servers) do
      local mason_name = lsp_to_mason(server)
      if registry.is_installed(mason_name) then
        registry.get_package(mason_name):uninstall()
      end
    end
  end,
}
