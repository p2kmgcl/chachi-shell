local M = {}
local notify = require("formatters.notify")

local lookup = {}
local langs_dir = vim.fn.stdpath("config") .. "/lua/formatters/languages"
for _, file in ipairs(vim.fn.readdir(langs_dir)) do
  if file:sub(-4) == ".lua" then
    local mod = "formatters.languages." .. file:sub(1, -5)
    local lang = require(mod)
    for _, ft in ipairs(lang.filetypes) do
      if not lookup[ft] then
        lookup[ft] = {}
      end
      table.insert(lookup[ft], lang)
    end
  end
end

for _, chain in pairs(lookup) do
  table.sort(chain, function(a, b)
    return (a.priority or 100) < (b.priority or 100)
  end)
end

function M.format()
  local ft = vim.bo.filetype
  local chain = lookup[ft]

  if not chain or #chain == 0 then
    notify.warn("No formatter configured for " .. ft)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    notify.warn("Buffer has no file name")
    return
  end

  notify.info("Formatting…")

  coroutine.wrap(function()
    local root = require("formatters.project").root()
    for _, lang in ipairs(chain) do
      local start = vim.uv.hrtime()
      local tool = lang.format(file, root)
      if tool then
        local ms = math.floor((vim.uv.hrtime() - start) / 1e6)
        notify.info(tool .. " (" .. ms .. "ms)")
      end
    end
  end)()
end

return M
