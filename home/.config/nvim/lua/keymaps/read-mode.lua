vim.keymap.set("n", "<leader>ur", function()
  local wo = vim.wo
  if wo.wrap then
    wo.conceallevel = 0
    wo.number = true
    wo.relativenumber = true
    wo.wrap = false
  else
    wo.conceallevel = 2
    wo.number = false
    wo.relativenumber = false
    wo.wrap = true
  end
end, { desc = "Toggle Read Mode" })
