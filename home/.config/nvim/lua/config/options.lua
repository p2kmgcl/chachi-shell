-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.grepprg = "rg --vimgrep --hidden --ignore-vcs --ignore-global --iglob !.git/*"
opt.scrolloff = 999
opt.spelllang = ""
opt.swapfile = false
opt.undofile = false
