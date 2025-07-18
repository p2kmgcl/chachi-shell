return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        local has_eslint = false
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if client.name == "eslint-lsp" then
            has_eslint = true
          end
        end

        if has_eslint then
          vim.lsp.buf.execute_command({
            command = "eslint.applyAllFixes",
            arguments = { { uri = vim.uri_from_bufnr(0), version = vim.lsp.util.buf_versions[0] } },
          })
        else
          local conform = require("conform")
          conform.format()
        end
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },
  opts = function()
    local flatten = require("common.helpers.flatten")
    local require_all = require("common.helpers.require-all")
    local formatters_by_ft = flatten(require_all("config/conform-formatters.lua"))

    return {
      format_on_save = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
      formatters_by_ft = formatters_by_ft,
    }
  end,
}
