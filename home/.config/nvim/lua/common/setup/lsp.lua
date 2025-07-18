local methods = vim.lsp.protocol.Methods

local function on_attach(client, bufnr)
  vim.keymap.set({ "n", "x" }, "gra", function()
    local tiny_code_action = require("tiny-code-action")
    tiny_code_action.code_action({ bufnr = bufnr })
  end, { desc = "vim.lsp.buf.code_action()", buffer = bufnr })

  if client:supports_method(methods.textDocument_signatureHelp) then
    vim.keymap.set("i", "<C-k>", function()
      if require("blink.cmp.completion.windows.menu").win:is_open() then
        require("blink.cmp").hide()
      end
      vim.lsp.buf.signature_help()
    end, { desc = "Signature help", buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end, 500)
  end
end

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
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
