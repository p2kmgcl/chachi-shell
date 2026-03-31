vim.lsp.enable({
  "bash-language-server",
  "css-lsp",
  -- "denols", -- Disabled to avoid conflicts with tsgo
  "dockerfile-language-server",
  "eslint-lsp",
  "fish-lsp",
  "gopls",
  "html-lsp",
  "json-lsp",
  "lua_ls",
  "rust-analyzer",
  "stylelint-lsp",
  "stylua",
  "tailwindcss-language-server",
  "tombi",
  "tsgo",
  "yaml-language-server",
})

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Patch LSP clients to suppress NO_RESULT_CALLBACK_FOUND from blocking the UI.
-- The default write_error uses nvim_echo with err=true which triggers "Press ENTER".
-- We override it to route that specific error to vim.notify (picked up by fidget).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client._patched_write_error then
      return
    end
    local original = client.write_error
    client.write_error = function(self, code, err)
      if code == vim.lsp.rpc.client_errors.NO_RESULT_CALLBACK_FOUND then
        vim.notify("LSP[" .. self.name .. "]: NO_RESULT_CALLBACK_FOUND", vim.log.levels.WARN)
        return
      end
      original(self, code, err)
    end
    client._patched_write_error = true
  end,
})
