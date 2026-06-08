local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  format = function(file, root)
    if not root or not p.has_glob(root, "eslint.config.*") then
      notify.warn("No eslint config found")
      return
    end

    if #vim.lsp.get_clients({ bufnr = 0, name = "eslint-lsp" }) > 0 then
      p.lsp_format("eslint-lsp")
      return "eslint-lsp"
    end

    if #vim.lsp.get_clients({ bufnr = 0, name = "tsgo" }) > 0 then
      p.lsp_format("tsgo")
      return "tsgo"
    end

    notify.warn("No TypeScript LSP active")
  end,
}
