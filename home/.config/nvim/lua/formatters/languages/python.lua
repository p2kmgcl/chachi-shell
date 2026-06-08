local p = require("formatters.project")
local notify = require("formatters.notify")

return {
  filetypes = { "python" },
  format = function(file, root)
    local has_ruff_toml = root and p.has_file(root, "ruff.toml", ".ruff.toml")
    local has_pyproject = root and p.has_file(root, "pyproject.toml")

    if not has_ruff_toml and not has_pyproject then
      notify.warn("No python formatter config found")
      return
    end

    if p.has_bin("ruff") then
      p.save_if_modified()
      local result = p.cli_run({ "ruff", "format", file })
      if result.code ~= 0 then
        local output = (result.stderr ~= "" and result.stderr) or result.stdout
        notify.error("Ruff: " .. output)
        return
      end
      p.reload()
      return "ruff"
    end

    if p.has_bin("black") then
      p.save_if_modified()
      local result = p.cli_run({ "black", file })
      if result.code ~= 0 then
        local output = (result.stderr ~= "" and result.stderr) or result.stdout
        notify.error("Black: " .. output)
        return
      end
      p.reload()
      return "black"
    end

    notify.warn("Ruff and black not found on PATH")
  end,
}
