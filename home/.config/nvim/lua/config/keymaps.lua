-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Change and delete without yank
map("n", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("v", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("n", "d", '"_d', { noremap = true, desc = "Delete without yank" })
map("v", "d", '"_d', { noremap = true, desc = "Delete without yank" })

-- Terminal mode escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
