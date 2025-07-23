vim.keymap.set({ "n" }, "<leader>ll", function()
  for _, client in pairs(vim.lsp.get_active_clients()) do
    print("LSP:", client.name)
    local cmds = client.server_capabilities.executeCommandProvider
    if cmds and cmds.commands then
      for _, cmd in ipairs(cmds.commands) do
        print("  - " .. cmd)
      end
    else
      print("  (no executeCommandProvider)")
    end
  end
  vim.cmd("messages")
end, { desc = "List available commands" })
