local utils = require("sidebar.utils")
local M = {}

local status_hl = { M = "DiagnosticWarn", A = "DiagnosticOk", D = "DiagnosticError", ["?"] = "Comment" }
local cached_items = {}
local refresh_pending = false

local function parse_status(output)
  local items = {}
  for _, line in ipairs(output) do
    if #line >= 3 then
      local staged, unstaged, path = line:sub(1, 1), line:sub(2, 2), line:sub(4)
      if path:find(" -> ") then path = path:match(" -> (.+)$") end
      local name = vim.fn.fnamemodify(path, ":t")
      local status = (staged ~= " " and staged ~= "?") and staged or unstaged
      items[#items + 1] = {
        path = path, name = name,
        staged = staged, unstaged = unstaged, status = status
      }
    end
  end
  table.sort(items, function(a, b) return a.path < b.path end)
  return items
end

local function enrich_items(items)
  for _, item in ipairs(items) do
    item.icon, item.icon_hl = utils.get_icon(item.name, "file")
  end
  return items
end

local function render(buf, items)
  local lines, entries, highlights = utils.render_tree(items, function(item, pad)
    local st = item.staged .. item.unstaged
    return pad .. st .. " " .. item.icon .. " " .. item.name, {
      { col_start = #pad, col_end = #pad + 2, hl = status_hl[item.status] or "Normal" },
      { col_start = #pad + 3, col_end = #pad + 3 + #item.icon, hl = item.icon_hl },
    }
  end)
  utils.set_lines(buf, lines, highlights)
  vim.b[buf].entries = entries
end

local function setup_keymaps(buf)
  vim.keymap.set("n", "<CR>", function()
    local entry = vim.b[buf].entries[vim.fn.line(".")]
    if entry and entry.path then
      require("edgy").goto_main()
      vim.cmd.edit(utils.get_git_root() .. "/" .. entry.path)
    end
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "ss", function()
    local entry = vim.b[buf].entries[vim.fn.line(".")]
    if entry and entry.path then
      local root = utils.get_git_root()
      local cmd = (entry.staged ~= " " and entry.staged ~= "?")
        and { "git", "-C", root, "restore", "--staged", entry.path }
        or { "git", "-C", root, "add", entry.path }
      vim.system(cmd, {}, function() vim.schedule(M.refresh) end)
    end
  end, { buffer = buf, nowait = true })
end

function M.open()
  local buf = utils.get_or_create_buffer("git")
  if not vim.b[buf].keymaps_set then
    setup_keymaps(buf)
    vim.b[buf].keymaps_set = true
  end
  render(buf, cached_items)
  utils.show_buffer(buf)
  M.refresh()
end

function M.refresh()
  local buf = utils.buffers.git
  if not buf or not vim.api.nvim_buf_is_valid(buf) or #vim.fn.win_findbuf(buf) == 0 then return end
  if refresh_pending then return end
  refresh_pending = true

  local root = utils.get_git_root()
  if not root then
    refresh_pending = false
    return
  end

  vim.system({ "git", "-C", root, "status", "--porcelain" }, { text = true }, function(obj)
    refresh_pending = false
    if obj.code == 0 then
      local raw_items = parse_status(vim.split(obj.stdout, "\n"))
      vim.schedule(function()
        cached_items = enrich_items(raw_items)
        if vim.api.nvim_buf_is_valid(buf) then
          render(buf, cached_items)
        end
      end)
    end
  end)
end

return M
