local M = {}

function M.get_buffer_clients(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local result = {}

  for _, client in ipairs(clients) do
    table.insert(result, {
      name = client.name,
      id = client.id,
    })
  end

  return result
end

function M.has_buffer_clients(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  return #clients > 0
end

function M.format_for_lualine()
  local clients = M.get_buffer_clients()

  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client_info in ipairs(clients) do
    table.insert(names, client_info.name)
  end

  return table.concat(names, " · ")
end

return M
