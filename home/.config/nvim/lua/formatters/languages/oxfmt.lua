local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  priority = 10,
  filetypes = {
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "css", "less", "scss",
    "html",
    "json", "jsonc",
    "yaml",
    "markdown",
    "graphql",
  },
  format = function(file, root)
    if not root then
      notify.warn("No project root found")
      return
    end

    if not p.has_glob(root, "oxfmt.config.*") then
      return
    end

    local cmd = p.node_bin(root, "oxfmt")
    if not cmd then
      notify.warn("Oxfmt not installed in project")
      return
    end

    p.save_if_modified()

    local args = vim.list_extend(vim.deepcopy(cmd), { "--write", file })
    local result = p.cli_run(args, root)
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout
      notify.error("Oxfmt: " .. output)
      return
    end

    p.reload()
    return "oxfmt"
  end,
}
