-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/treesitter.lua

local toggle_inc_selection_group = vim.api.nvim_create_augroup("toggle_inc_selection", {
  clear = true,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  desc = "Disable incremental selection when entering the cmdline window",
  group = toggle_inc_selection_group,
  command = "TSBufDisable incremental_selection",
})

vim.api.nvim_create_autocmd("CmdwinLeave", {
  desc = "Enable incremental selection when leaving the cmdline window",
  group = toggle_inc_selection_group,
  command = "TSBufEnable incremental_selection",
})
