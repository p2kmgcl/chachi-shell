local min_width = 30
local max_width = 80
local padding = 2
local right_reserve = 8
local debounce_ms = 50

local timer = nil

local indent_size = 2
local icon_width = 2

local function node_display_width(node)
  local depth = node:get_depth() or 1
  local indent = (depth - 1) * indent_size
  local name = node.name or ""
  return indent + icon_width + vim.fn.strdisplaywidth(name)
end

local function measure_from_state()
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if not ok then
    return nil
  end
  local longest = 0
  for _, source in ipairs({ "filesystem", "buffers", "git_status" }) do
    local state = manager.get_state(source)
    if state and state.tree then
      for _, node in ipairs(state.tree:get_nodes()) do
        local function walk(n)
          local w = node_display_width(n)
          if w > longest then
            longest = w
          end
          if n:is_expanded() then
            for _, c in ipairs(state.tree:get_nodes(n:get_id())) do
              walk(c)
            end
          end
        end
        walk(node)
      end
    end
  end
  return longest > 0 and longest or nil
end

local function find_neotree_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" then
      return win, buf
    end
  end
  return nil, nil
end

local function fit_width()
  local win, buf = find_neotree_win()
  if not win then
    return
  end
  local longest = measure_from_state() or 0
  local target = math.max(min_width, math.min(max_width, longest + right_reserve + padding))
  if vim.api.nvim_win_get_width(win) ~= target then
    vim.api.nvim_win_set_width(win, target)
  end
end

local function schedule_fit()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
  timer = vim.uv.new_timer()
  timer:start(debounce_ms, 0, vim.schedule_wrap(function()
    if timer then
      timer:close()
      timer = nil
    end
    fit_width()
  end))
end

local attached = {}

local function attach_buf(buf)
  if attached[buf] then
    return
  end
  attached[buf] = true
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function()
      if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "neo-tree" then
        attached[buf] = nil
        return true
      end
      schedule_fit()
    end,
    on_detach = function()
      attached[buf] = nil
    end,
  })
end

local function attach_all_neotree_bufs()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "neo-tree" then
      attach_buf(buf)
    end
  end
end

local group = vim.api.nvim_create_augroup("NeoTreeAutoResize", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  desc = "Attach line-change listener to neo-tree buffers",
  group = group,
  pattern = "neo-tree",
  callback = function(args)
    attach_buf(args.buf)
    schedule_fit()
  end,
})

attach_all_neotree_bufs()

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWinEnter",
  "CursorMoved",
  "TextChanged",
  "WinResized",
  "DirChanged",
  "BufWritePost",
}, {
  desc = "Auto-resize neo-tree window to fit longest visible entry",
  group = group,
  callback = schedule_fit,
})

vim.api.nvim_create_autocmd("User", {
  desc = "Auto-resize neo-tree on its lifecycle events",
  group = group,
  pattern = {
    "NeoTreeBufferEnter",
    "NeoTreeBufferLeave",
    "NeoTreeWindowAfterOpen",
    "NeoTreeFileOpened",
    "NeoTreeFileAdded",
    "NeoTreeFileRenamed",
    "NeoTreeFileDeleted",
  },
  callback = schedule_fit,
})
