vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.keymap.set("n", "c", '"_c', { noremap = true, desc = "Change without yank" })
vim.keymap.set("v", "c", '"_c', { noremap = true, desc = "Change without yank" })
vim.keymap.set("n", "d", '"_d', { noremap = true, desc = "Delete without yank" })
vim.keymap.set("v", "d", '"_d', { noremap = true, desc = "Delete without yank" })
