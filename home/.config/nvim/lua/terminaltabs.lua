-- Exit terminal mode pressing Escape key
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Allow navigating outside of terminal tabs
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { silent = true })

-- Allow resizing terminal tabs
vim.keymap.set("t", "<M-h>", "<C-\\><C-n><C-w><i", { silent = true })
vim.keymap.set("t", "<M-j>", "<C-\\><C-n><C-w>-i", { silent = true })
vim.keymap.set("t", "<M-k>", "<C-\\><C-n><C-w>+i", { silent = true })
vim.keymap.set("t", "<M-l>", "<C-\\><C-n><C-w>>i", { silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})
