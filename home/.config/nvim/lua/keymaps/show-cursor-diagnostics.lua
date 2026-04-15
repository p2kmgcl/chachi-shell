vim.keymap.set("n", "<leader>cd", function()
  local max_height = math.floor(vim.o.lines * 0.3)
  -- Run twice to auto focus then the float is displayed
  vim.diagnostic.open_float(nil, { focus = true, max_height = max_height })
  vim.diagnostic.open_float(nil, { focus = true, max_height = max_height })
end, { desc = "Show diagnostic in cursor" })
