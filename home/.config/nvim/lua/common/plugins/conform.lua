return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        local conform = require("conform")
        conform.format({ async = false })

        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if client.name == "eslint-lsp" then
            client:request_sync(vim.lsp.protocol.Methods.workspace_executeCommand, {
              command = "eslint.applyAllFixes",
              arguments = { { uri = vim.uri_from_bufnr(0) } },
            })
          end
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
