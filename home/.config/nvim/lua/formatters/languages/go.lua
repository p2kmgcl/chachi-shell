local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "go" },
  format = function(file, root)
    if not root or not p.has_file(root, "go.mod") then
      notify.warn("No go.mod found")
      return
    end
    if p.lsp_format("gopls") then return "gopls" end
  end,
}
