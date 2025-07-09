local function js_formatter(bufnr)
  if require("conform").get_formatter_info("eslint_d", bufnr).available then
    return { "eslint_d" }
  elseif require("conform").get_formatter_info("prettier", bufnr).available then
    return { "prettier" }
  else
    return {}
  end
end

return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      javascript = js_formatter,
      typescript = js_formatter,
      javascriptreact = js_formatter,
      typescriptreact = js_formatter,
    },
  },
}