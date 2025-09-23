local formatter_priority = {
  javascript = { "eslint-lsp", "vtsls" },
  javascriptreact = { "eslint-lsp", "vtsls" },
  lua = { "stylua", "lua_ls" },
  typescript = { "eslint-lsp", "vtsls" },
  typescriptreact = { "eslint-lsp", "vtsls" },
}

local function lsp_preference_filter(client)
  local filetype = vim.bo.filetype
  local preferred_formatters = formatter_priority[filetype]

  if not preferred_formatters then
    vim.notify("formatting with " .. client.name, vim.log.levels.INFO)
    return true
  end

  for _, name in ipairs(preferred_formatters) do
    local active = vim.lsp.get_clients({ bufnr = 0, name = name })
    if #active > 0 then
      vim.notify("formatting with " .. name, vim.log.levels.INFO)
      return client.name == name
    end
  end

  vim.notify("formatting with " .. client.name, vim.log.levels.INFO)
  return true
end

vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({
    bufnr = 0,
    async = false,
    filter = lsp_preference_filter,
  })
end, { desc = "Format buffer" })
