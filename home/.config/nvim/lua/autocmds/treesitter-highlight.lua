vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable built-in treesitter highlighting",
  group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
