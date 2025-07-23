local methods = vim.lsp.protocol.Methods
local register_capability = vim.lsp.handlers[methods.client_registerCapability]

local function on_attach(client, bufnr)
  if client:supports_method(methods.textDocument_inlayHint) then
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end, 500)
  end
end

vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client then
    on_attach(client, vim.api.nvim_get_current_buf())
    return register_capability(err, res, ctx)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})
