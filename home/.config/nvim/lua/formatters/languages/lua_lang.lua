local p = require("formatters.project")

return {
  filetypes = { "lua" },
  format = function(file, root)
    if p.lsp_format("stylua") then return "stylua" end
  end,
}
