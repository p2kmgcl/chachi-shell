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
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },
  opts = function()
    return {
      formatters_by_ft = {
        ["_"] = { "prettier" },
        javascript = { "eslint_d", "prettier", stop_after_first = false },
        javascriptreact = { "eslint_d", "prettier", stop_after_first = false },
        lua = { "stylua" },
        sh = { "shfmt" },
        typescript = { "eslint_d", "prettier", stop_after_first = false },
        typescriptreact = { "eslint_d", "prettier", stop_after_first = false },
        yaml = { "yamlfmt" },
      },
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
    }
  end,
}
