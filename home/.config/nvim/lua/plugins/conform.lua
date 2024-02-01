local function prefer_liferay_formatter(default_formatters)
  return function(bufnr)
    local conform = require("conform")
    local formatter_info = conform.get_formatter_info("liferay_uglier", bufnr)

    if formatter_info.available then
      return { "liferay_uglier" }
    end

    return default_formatters
  end
end

return {
  {
    "conform.nvim",
    opts = {
      format = {
        async = false,
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        css = prefer_liferay_formatter({ "prettier" }),
        html = prefer_liferay_formatter({ "prettier" }),
        scss = prefer_liferay_formatter({ "prettier" }),
        javascript = prefer_liferay_formatter({ "prettier" }),
        javascriptreact = prefer_liferay_formatter({ "prettier" }),
        json = prefer_liferay_formatter({ "prettier" }),
        typescript = prefer_liferay_formatter({ "prettier" }),
        typescriptreact = prefer_liferay_formatter({ "prettier" }),
      },
      formatters = {
        liferay_uglier = {
          command = "npx",
          args = function(self, ctx)
            return {
              "liferay-npm-scripts",
              "prettier",
              "--stdin",
              "--stdin-filepath",
              vim.api.nvim_buf_get_name(ctx.buf),
            }
          end,
          stdin = true,
          require_cwd = true,
          cwd = require("conform.util").root_file({
            "package.json",
          }),
          condition = function(self, ctx)
            local portal_path = os.getenv("LIFERAY_PORTAL_PATH")
            if portal_path == nil then
              return false
            end

            local buffer_path = vim.api.nvim_buf_get_name(ctx.buf)
            return vim.startswith(buffer_path, portal_path)
          end,
        },
      },
    },
  },
}
