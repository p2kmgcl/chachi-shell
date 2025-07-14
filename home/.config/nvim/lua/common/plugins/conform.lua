return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  cmd = "ConformInfo",
  opts = function()
    return {
      format_on_save = {
        async = false,
        quiet = false,
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = require('common.helpers.flatten')({
        require('common.config.conform-formatters'),
        require('js.config.conform-formatters'),
      }),
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
