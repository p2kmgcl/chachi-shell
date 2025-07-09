return {
  "mason-org/mason-lspconfig.nvim",
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

    return {
      ensure_installed = enabled_servers,
    }
  end,
}
