local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "css", "less", "scss" },
  format = function(file, root)
    if not root or not p.has_glob(root, "stylelint.config.*") then
      notify.warn("No stylelint config found")
      return
    end

    local cmd = p.node_bin(root, "stylelint")
    if not cmd then
      notify.warn("Stylelint not installed in project")
      return
    end

    p.save_if_modified()

    local args = vim.list_extend(vim.deepcopy(cmd), { file, "--fix" })
    local result = p.cli_run(args, root)
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout
      notify.error("Stylelint: " .. output)
      return
    end

    p.reload()
    return "stylelint"
  end,
}
