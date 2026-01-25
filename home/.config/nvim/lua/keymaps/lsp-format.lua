local formatter_priority = {
  css = { "stylelint-lsp", "css-lsp" },
  javascript = { "eslint-lsp", "tsgo", "vtsls" },
  javascriptreact = { "eslint-lsp", "tsgo", "vtsls" },
  less = { "stylelint-lsp", "css-lsp" },
  lua = { "stylua", "lua_ls" },
  scss = { "stylelint-lsp", "css-lsp" },
  typescript = { "eslint-lsp", "tsgo", "vtsls" },
  typescriptreact = { "eslint-lsp", "tsgo", "vtsls" },
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

local function format_with_stylelint(file)
  if file == "" then
    vim.notify("no file name for stylelint format", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  local result = vim.system({ "npx", "stylelint", file, "--fix" }, { text = true }):wait()

  if result.code ~= 0 then
    local output = (result.stderr ~= "" and result.stderr) or result.stdout
    vim.notify("stylelint failed: " .. output, vim.log.levels.ERROR)
    return
  end

  vim.cmd("silent! checktime")
end

vim.keymap.set("n", "<leader>cf", function()
  local use_stylelint = lsp_preference_filter({ name = "stylelint-lsp" })

  if use_stylelint then
    local file = vim.api.nvim_buf_get_name(0)
    format_with_stylelint(file)
  else
    vim.lsp.buf.format({
      bufnr = 0,
      async = false,
      filter = lsp_preference_filter,
    })
  end
end, { desc = "Format buffer" })
