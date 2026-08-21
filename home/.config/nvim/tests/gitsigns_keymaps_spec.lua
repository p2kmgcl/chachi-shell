local spec = dofile("home/.config/nvim/lua/plugins/gitsigns.lua")

local function has_mode(mapping, wanted)
  local mode = mapping.mode or "n"
  if type(mode) == "string" then
    return mode == wanted
  end
  return vim.tbl_contains(mode, wanted)
end

local function find_mapping(lhs, mode)
  for _, mapping in ipairs(spec.keys or {}) do
    if mapping[1] == lhs and has_mode(mapping, mode) then
      return mapping
    end
  end
end

local normal = assert(find_mapping("<leader>hs", "n"), "missing normal-mode hunk stage mapping")
local visual = assert(find_mapping("<leader>hs", "v"), "missing visual-mode partial hunk stage mapping")

local calls = {}
package.loaded.gitsigns = {
  stage_hunk = function(range)
    calls[#calls + 1] = range or false
  end,
}

normal[2]()
assert(calls[1] == false, "normal mapping should stage the hunk at the cursor")

local original_line = vim.fn.line
vim.fn.line = function(mark)
  return mark == "." and 8 or 3
end
visual[2]()
vim.fn.line = original_line

assert(vim.deep_equal(calls[2], { 8, 3 }), "visual mapping should stage the selected line range")
