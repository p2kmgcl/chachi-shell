vim.keymap.set({ "n" }, "<leader>ll", function()
  local commands = {}

  for _, client in pairs(vim.lsp.get_clients()) do
    local cmds = client.server_capabilities.executeCommandProvider
    if cmds and cmds.commands then
      for _, cmd in ipairs(cmds.commands) do
        table.insert(commands, {
          command = cmd,
          client_name = client.name,
          client_id = client.id,
        })
      end
    end
  end

  if #commands == 0 then
    vim.notify("No LSP commands available", vim.log.levels.WARN)
    return
  end

  vim.ui.select(commands, {
    prompt = "Select LSP Command:",
    format_item = function(item)
      return string.format("%s: %s", item.client_name, item.command)
    end,
  }, function(selected)
    if not selected then
      return
    end

    vim.lsp.buf.execute_command({
      command = selected.command,
    })
  end)
end, { desc = "LSP Commands" })
