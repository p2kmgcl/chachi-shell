vim.keymap.set("n", "<leader>cf", function()
  require("formatters.dispatch").format()
end, { desc = "Format buffer" })
