local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "rust" },
  format = function(file, root)
    if not root or not p.has_file(root, "Cargo.toml") then
      notify.warn("No Cargo.toml found")
      return
    end
    if p.lsp_format("rust-analyzer") then return "rust-analyzer" end
  end,
}
