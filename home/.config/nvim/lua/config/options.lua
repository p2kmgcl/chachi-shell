-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

local opt = vim.opt

opt.grepprg = "rg --vimgrep --hidden"
opt.undofile = false
opt.swapfile = false
