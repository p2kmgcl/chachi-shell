if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<leader>gg", function()
    require('snacks').lazygit()
  end, { desc = "Lazygit" })
end
