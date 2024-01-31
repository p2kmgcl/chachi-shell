-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

local opt = vim.opt

opt.grepprg = "rg --vimgrep --hidden"
opt.undofile = false
opt.swapfile = false

-- Nice color column
local colorcolumn = "80"
for i = 81, 335 do
  colorcolumn = colorcolumn .. "," .. i
end
opt.colorcolumn = colorcolumn
