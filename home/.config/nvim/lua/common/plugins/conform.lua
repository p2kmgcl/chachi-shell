return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },
  opts = function()
    return {
      format_on_save = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = require("common.helpers.flatten")({
        require("common.config.conform-formatters"),
        require("js.config.conform-formatters"),
      }),
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
