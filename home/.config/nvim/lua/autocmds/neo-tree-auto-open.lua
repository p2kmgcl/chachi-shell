vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto-open neo-tree on startup",
  group = vim.api.nvim_create_augroup("NeoTreeAutoOpen", { clear = true }),
  callback = function()
    if vim.g.started_with_stdin then
      return
    end
    vim.schedule(function()
      vim.cmd("Neotree show")
    end)
  end,
})

vim.api.nvim_create_autocmd("StdinReadPre", {
  group = vim.api.nvim_create_augroup("NeoTreeStdinGuard", { clear = true }),
  callback = function()
    vim.g.started_with_stdin = true
  end,
})
