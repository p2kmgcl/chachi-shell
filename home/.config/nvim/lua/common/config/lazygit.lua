-- lazygit
if vim.fn.executable("lazygit") == 1 then
  local map = vim.keymap.set
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
end
