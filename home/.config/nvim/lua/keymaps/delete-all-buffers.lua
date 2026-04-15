vim.keymap.set("n", "<leader>ba", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
      if buf_type ~= "terminal" then
        vim.api.nvim_buf_delete(buf, { force = false })
      end
    end
  end
end, { desc = "Delete All Buffers" })
