-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local Util = require("lazyvim.util")

vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_bcommits<cr>", { desc = "buffer commits" })
vim.keymap.set("n", "<leader>fd", "<cmd>DevdocsOpen<cr>", { desc = "Find devdocs" })
