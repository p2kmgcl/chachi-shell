local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "bash", "sh" },
  format = function(file, root)
    if not p.has_bin("shfmt") then
      notify.warn("Shfmt not found on PATH")
      return
    end

    p.save_if_modified()

    local result = p.cli_run({ "shfmt", "-w", file })
    if result.code ~= 0 then
      local output = (result.stderr ~= "" and result.stderr) or result.stdout
      notify.error("Shfmt: " .. output)
      return
    end

    p.reload()
    return "shfmt"
  end,
}
