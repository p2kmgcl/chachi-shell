-- Configure diagnostic display
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
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