local scan = require("a-side.regions.explorer.scan")
local watcher = require("a-side.regions.explorer.watcher")
local mutations = require("a-side.regions.explorer.mutations")
local tree = require("a-side.ui.tree.tree")
local refresh_indicators = require("a-side.decorators.refresh_indicators")

local DEBOUNCE_MS = 100

local M = {
  name = "explorer",
  filetype = "aside-explorer",
}

local state

local function fresh_state()
  return {
    bufnr = nil,
    root = nil,
    cache = {},
    pending = {},
    watchers = nil,
    dirty = {},
    dirty_timer = nil,
    handle = nil,
    augroup = nil,
    clipboard = nil,  -- { path, op = 'cut'|'copy' }
  }
end

state = fresh_state()

local function attach_paths(dir, items)
  for _, it in ipairs(items) do
    it.path = dir .. "/" .. it.name
  end
end

local function scan_dir(dir)
  state.cache[dir] = scan.list_sync(dir)
  attach_paths(dir, state.cache[dir])
  if state.handle then
    state.handle:render()
  end
  if state.pending[dir] then
    return
  end
  state.pending[dir] = true
  scan.filter_async(dir, state.cache[dir], function(filtered)
    state.pending[dir] = nil
    if dir ~= state.root and not state.cache[dir] then
      return
    end
    state.cache[dir] = filtered
    attach_paths(dir, filtered)
    if state.handle then
      state.handle:render()
    end
  end)
end

local function flush_dirty()
  local dirs = state.dirty
  state.dirty = {}
  for d, _ in pairs(dirs) do
    if d == state.root or state.cache[d] then
      scan_dir(d)
    end
  end
end

local function on_dir_dirty(dir)
  state.dirty[dir] = true
  if not state.dirty_timer then
    return
  end
  state.dirty_timer:stop()
  state.dirty_timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(flush_dirty))
end

-- Inject clipboard annotation into a child list without mutating cache entries.
local function get_children(path)
  local children = state.cache[path]
  if not children or not state.clipboard then
    return children
  end
  local clip_path = state.clipboard.path
  local ann_id = state.clipboard.op == 'cut' and 'clipboard_cut' or 'clipboard_copy'
  local result = {}
  for _, item in ipairs(children) do
    if item.path == clip_path then
      local copy = vim.tbl_extend('force', {}, item)
      copy.annotations = { ann_id }
      result[#result + 1] = copy
    else
      result[#result + 1] = item
    end
  end
  return result
end

local function on_expand(path)
  if state.watchers then
    state.watchers.start(path, on_dir_dirty)
  end
  if not state.cache[path] then
    scan_dir(path)
  end
end

local function on_collapse(path)
  if state.watchers then
    state.watchers.stop(path)
  end
  state.cache[path] = nil
end

local function clear_clipboard()
  if not state.clipboard then return end
  state.clipboard = nil
  if state.handle then
    state.handle:render()
  end
end

-- Returns the destination directory for create/paste given the entry under
-- the cursor: directories yield themselves; files yield their parent.
local function dest_dir_for(entry)
  if not entry then return state.root end
  if entry.is_dir then
    return entry.path
  else
    return entry.path:match('^(.*)/[^/]+$') or state.root
  end
end

-- Rescan the parent directory of path and trigger a view resize.
local function refresh_after(path)
  local parent = path:match('^(.*)/[^/]+$') or state.root
  scan_dir(parent)
  local ok, view = pcall(require, "a-side.view")
  if ok then view.resize("explorer") end
end

function M.render(bufnr)
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
  vim.bo[bufnr].modifiable = false
end

function M.enable(bufnr)
  if state.watchers then
    state.watchers.stop_all()
  end
  if state.dirty_timer and not state.dirty_timer:is_closing() then
    state.dirty_timer:close()
  end
  if state.handle then
    state.handle:destroy()
  end

  state = fresh_state()
  state.bufnr = bufnr
  state.root = vim.fn.getcwd()
  state.watchers = watcher.new()
  state.dirty_timer = vim.uv.new_timer()

  state.handle = tree.new({
    bufnr = bufnr,
    root_path = state.root,
    root_label = " Explorer・" .. vim.fn.fnamemodify(state.root, ":t") .. "/",
    get_children = get_children,
    initially_expanded = false,
    on_expand = on_expand,
    on_collapse = on_collapse,
    on_select = function(entry, action)
      local cmds = { edit = "edit", vsplit = "vsplit", hsplit = "split", tab = "tabedit" }
      local ok, view = pcall(require, "a-side.view")
      if ok then vim.api.nvim_set_current_win(view.ensure_editor_win()) end
      vim.cmd((cmds[action] or "edit") .. " " .. vim.fn.fnameescape(entry.path))
    end,
    on_render = function()
      local ok, view = pcall(require, "a-side.view")
      if ok then
        view.resize("explorer")
      end
      refresh_indicators.tick(state.bufnr)
    end,
  })

  state.watchers.start(state.root, on_dir_dirty)
  scan_dir(state.root)

  state.augroup = vim.api.nvim_create_augroup("ASideExplorer", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = state.augroup,
    callback = function(ev)
      if not state.handle then return end
      local path = vim.api.nvim_buf_get_name(ev.buf)
      if path == "" then return end
      if path:sub(1, #state.root + 1) ~= state.root .. "/" then return end
      state.handle:reveal(path)
    end,
  })

  -- Clear clipboard when explorer window loses focus.
  vim.api.nvim_create_autocmd("WinLeave", {
    group = state.augroup,
    buf = bufnr,
    callback = function()
      clear_clipboard()
    end,
  })

  -- a: create file or directory
  vim.keymap.set('n', 'a', function()
    if not state.handle then return end
    local entry = state.handle:cursor_entry()
    local dir = dest_dir_for(entry)
    mutations.create(dir, function(path)
      if path then
        refresh_after(path)
        state.handle:reveal(path)
      end
    end)
  end, { buffer = bufnr, nowait = true, silent = true })

  -- r: rename in place
  vim.keymap.set('n', 'r', function()
    if not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry then return end
    local old_parent = entry.path:match('^(.*)/[^/]+$') or state.root
    mutations.rename(entry, function(new_path)
      if new_path then
        scan_dir(old_parent)
        local new_parent = new_path:match('^(.*)/[^/]+$') or state.root
        if new_parent ~= old_parent then scan_dir(new_parent) end
        -- reveal tracks the renamed file so the cursor doesn't jump to parent
        state.handle:reveal(new_path)
        local ok, view = pcall(require, "a-side.view")
        if ok then view.resize("explorer") end
      end
    end)
  end, { buffer = bufnr, nowait = true, silent = true })

  -- x: cut
  vim.keymap.set('n', 'x', function()
    if not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry then return end
    state.clipboard = { path = entry.path, op = 'cut' }
    state.handle:render()
    vim.notify('a-side: cut ' .. entry.name, vim.log.levels.INFO)
  end, { buffer = bufnr, nowait = true, silent = true })

  -- y: copy
  vim.keymap.set('n', 'y', function()
    if not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry then return end
    state.clipboard = { path = entry.path, op = 'copy' }
    state.handle:render()
    vim.notify('a-side: copied ' .. entry.name, vim.log.levels.INFO)
  end, { buffer = bufnr, nowait = true, silent = true })

  -- p: paste
  vim.keymap.set('n', 'p', function()
    if not state.handle then return end
    if not state.clipboard then return end
    local entry = state.handle:cursor_entry()
    local dir = dest_dir_for(entry)
    local clip = state.clipboard
    -- guard against pasting into itself
    if dir == clip.path or dir:sub(1, #clip.path + 1) == clip.path .. '/' then
      vim.notify('a-side: cannot paste into itself', vim.log.levels.WARN)
      return
    end
    if clip.op == 'copy' then
      mutations.paste_copy(clip.path, dir, function(new_path)
        if new_path then
          clear_clipboard()
          refresh_after(new_path)
          state.handle:reveal(new_path)
        end
      end)
    else
      local old_parent = clip.path:match('^(.*)/[^/]+$') or state.root
      mutations.paste_move(clip.path, dir, function(new_path)
        if new_path then
          clear_clipboard()
          scan_dir(old_parent)
          refresh_after(new_path)
          state.handle:reveal(new_path)
        end
      end)
    end
  end, { buffer = bufnr, nowait = true, silent = true })

  -- D: delete
  vim.keymap.set('n', 'D', function()
    if not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry then return end
    local parent = entry.path:match('^(.*)/[^/]+$') or state.root
    mutations.delete(entry, function(deleted)
      if deleted then
        -- if deleted node was in clipboard, clear it
        if state.clipboard and state.clipboard.path == entry.path then
          state.clipboard = nil
        end
        scan_dir(parent)
        local ok, view = pcall(require, "a-side.view")
        if ok then view.resize("explorer") end
      end
    end)
  end, { buffer = bufnr, nowait = true, silent = true })

  -- <Esc>: clear clipboard
  vim.keymap.set('n', '<Esc>', function()
    clear_clipboard()
  end, { buffer = bufnr, nowait = true, silent = true })
end

function M.cursor_path()
  if not state.handle then return nil end
  return dest_dir_for(state.handle:cursor_entry())
end

function M.disable()
  if state.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
  end
  if state.watchers then
    state.watchers.stop_all()
  end
  if state.dirty_timer and not state.dirty_timer:is_closing() then
    state.dirty_timer:stop()
    state.dirty_timer:close()
  end
  if state.handle then
    state.handle:destroy()
  end
  state = fresh_state()
end

return M
