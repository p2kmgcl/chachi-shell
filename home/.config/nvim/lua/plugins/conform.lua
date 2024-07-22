-- Autoformat
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[C]ode [F]ormat",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 1000,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      css = { "stylelint" },
      lua = { "stylua" },
      scss = { "stylelint" },
      javascript = { "prettier", "prettierd", "eslint", "tsserver" },
      typescript = { "prettier", "prettierd", "eslint", "tsserver" },
      typescriptreact = { "prettier", "prettierd", "eslint", "tsserver" },
    },
  },
}
