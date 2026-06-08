local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "markdown" },
  format = function(file, root)
    if not root then
      notify.warn("No project root found")
      return
    end

    local cmd = p.node_bin(root, "prettier")
    if not cmd then
      notify.warn("Prettier not installed in project")
      return
    end

    p.save_if_modified()

    local args = vim.list_extend(vim.deepcopy(cmd), { "--write", file })
    local result = p.cli_run(args, root)
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout
      notify.error("Prettier: " .. output)
      return
    end

    p.reload()
    return "prettier"
  end,
}
