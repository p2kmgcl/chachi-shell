vim.keymap.set({ "n" }, "<leader>ll", function()
  for _, client in pairs(vim.lsp.get_active_clients()) do
    print("LSP:", client.name)
    local cmds = client.server_capabilities.executeCommandProvider
    if cmds and cmds.commands then
      for _, cmd in ipairs(cmds.commands) do
        print("  - " .. cmd)
      end
    else
      print("  (no executeCommandProvider)")
    end
  end
  vim.cmd('messages')
end, {desc = "List available commands" })

local function on_attach(client, bufnr)
  -- Native keymap
  -- vim.keymap.set({ "n", "x" }, "grA", function() end)

  vim.keymap.set({ "n", "x" }, "grA", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { "source" },
        diagnostics = {},
      },
    })
  end, { desc = 'vim.lsp.buf.code_action("source")', buffer = bufnr })

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
    vim.keymap.set("i", "<C-k>", function()
      if require("blink.cmp.completion.windows.menu").win:is_open() then
        require("blink.cmp").hide()
      end
      vim.lsp.buf.signature_help()
    end, { desc = "Signature help", buffer = bufnr })
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end, 500)
  end
end

local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
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
