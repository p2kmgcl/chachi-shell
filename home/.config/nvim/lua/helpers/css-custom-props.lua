local M = {}

local cache = { items = nil, root = nil, ts = 0 }
local CACHE_MS = 5000

local function now_ms()
  return vim.loop.hrtime() / 1e6
end

local function project_root()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, c in ipairs(clients) do
    if c.config and c.config.root_dir then
      return c.config.root_dir
    end
    local ws = c.config and c.config.workspace_folders
    if ws and ws[1] and ws[1].name then
      return ws[1].name
    end
  end
  return vim.fn.getcwd()
end

local function rg_collect(root)
  -- Capture name + value (up to ';' or end of line)
  -- Group 1: --prop-name
  -- Group 2: value
  local pattern = [[^\s*(--(?=[-_]*[A-Za-z0-9_])[A-Za-z0-9_-]*)\s*:\s*([^;]+)]]

  local cmd = {
    "rg",
    "-NI",
    "--glob", "**/*.css",
    "--glob", "!**/node_modules/**",
    "--glob", "!**/dist/**",
    "--glob", "!**/.next/**",
    "--pcre2",
    "--with-filename",
    "--line-number",
    "--no-heading",
    "--color", "never",
    "--replace", "$1\t$2", -- output "name<TAB>value" (but still prefixed by file:line:)
    pattern,
  }

  local res = vim.system(cmd, { cwd = root, text = true }):wait()

  -- rg exit codes: 0 matches, 1 no matches, 2 error
  if res.code == 1 then return {} end
  if res.code ~= 0 then return {} end

  local lines = vim.split(res.stdout or "", "\n", { trimempty = true })

  -- Dedup by name; keep the first occurrence we see.
  local by_name = {}

  for _, line in ipairs(lines) do
    -- file:line:<replaced>
    local file, lnum, rest = line:match("^(.-):(%d+):(.*)$")
    if file and lnum and rest then
      local name, value = rest:match("^(%-%-[^\t]+)\t(.+)$")
      if name and value then
        name = vim.trim(name)
        value = vim.trim(value)

        if not by_name[name] then
          by_name[name] = {
            name = name,
            value = value,
            file = file,
            lnum = tonumber(lnum),
          }
        end
      end
    end
  end

  local items = {}
  for _, rec in pairs(by_name) do
    items[#items + 1] = rec
  end
  table.sort(items, function(a, b) return a.name < b.name end)
  return items
end

local function get_items()
  local root = project_root()
  local t = now_ms()

  if cache.items and cache.root == root and (t - cache.ts) < CACHE_MS then
    return cache.items
  end

  cache.items = rg_collect(root)
  cache.root = root
  cache.ts = t
  return cache.items
end

-- Returns prefix after `var(--` (including the leading `--` and any typed chars)
local function var_prefix_ctx(ctx)
  local line = ctx and ctx.line or vim.api.nvim_get_current_line()
  local col = (ctx and ctx.col) or vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)

  -- Match: var(   --<prefix>
  -- Captures from `--` up to cursor.
  local start = before:match(".*var%(%s*(%-%-[%w_-]*)$")
  if not start then return nil end
  return start
end

function M.new()
  return setmetatable({}, { __index = M })
end

function M:get_completions(ctx, callback)
  -- Only CSS
  if vim.bo.filetype ~= "css" then
    return callback({ items = {}, is_incomplete = false })
  end

  -- Only when typing inside `var(--...`
  local prefix = var_prefix_ctx(ctx)

  if not prefix then
    return callback({ items = {}, is_incomplete = false })
  end

  local vars = get_items() -- now returns { {name,value,file,lnum}, ... }

  local items = {}
  for _, rec in ipairs(vars) do
    if rec.name:sub(1, #prefix) == prefix then
      items[#items + 1] = {
        label = rec.name,        -- what you see in the menu
        insertText = rec.name,   -- what gets inserted (you already typed `var(`)
        detail = rec.value,      -- shows value in the UI (when supported)
        documentation = {
          kind = "markdown",
          value = ("`%s: %s`\n\n%s:%d"):format(rec.name, rec.value, rec.file, rec.lnum),
        },
        kind = "Variable",
      }
    end
  end

  callback({ items = items, is_incomplete = false })
end

return M
