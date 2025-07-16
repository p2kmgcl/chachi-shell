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
        injected = { options = { ignore_errors = true } },
      },
      formatters_by_ft = formatters_by_ft,
    }
  end,
}
