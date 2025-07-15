vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  float = {
    focusable = false,
    border = "rounded",
    source = "always",
  },
})

-- Simple debounce using timer
local diagnostic_timer = nil
local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  if diagnostic_timer then
    diagnostic_timer:stop()
  end
  diagnostic_timer = vim.uv.new_timer()
  diagnostic_timer:start(1000, 0, function()
    vim.schedule(function()
      original_handler(err, result, ctx, config)
    end)
  end)
end

-- Default keymaps
-- vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- vim.keymap.set("n", "]d", vim.diagnostic.go_to_next, { desc = "Next Diagnostic" })
-- vim.keymap.set("n", "[d", vim.diagnostic.go_to_prev, { desc = "Prev Diagnostic" })
-- vim.keymap.set("n", "]D", vim.diagnostic.go_to_last, { desc = "Last Diagnostic" })
-- vim.keymap.set("n", "[D", vim.diagnostic.go_to_first, { desc = "First Diagnostic" })

-- Enable diagnostics
vim.diagnostic.enable()
