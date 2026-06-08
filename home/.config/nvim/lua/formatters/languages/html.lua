local p = require("formatters.project")

return {
  filetypes = { "html" },
  format = function(file, root)
    if p.lsp_format("html-lsp") then return "html-lsp" end
  end,
}
