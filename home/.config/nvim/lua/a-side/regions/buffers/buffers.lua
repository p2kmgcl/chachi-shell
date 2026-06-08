local list = require('a-side.regions.buffers.list')
local tree = require('a-side.ui.tree.tree')
local refresh_indicators = require('a-side.decorators.refresh_indicators')

local M = {
  name = 'buffers',
  filetype = 'aside-buffers',
}

local state = {
  bufnr = nil,
  augroup = nil,
  handle = nil,
  children = {},
  cwd = nil,
  scheduled = false,
}

local function collect_bufs()
  local out = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.bo[b].buftype == '' then
      out[#out + 1] = {
        bufnr = b,
        name = vim.api.nvim_buf_get_name(b),
        modified = vim.bo[b].modified,
      }
    end
  end
  return out
end

local function rebuild()
  state.scheduled = false
  if not (state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr)) then return end
  state.cwd = vim.fn.getcwd()
  state.children = list.parse(collect_bufs(), state.cwd)
  if state.handle then
    state.handle:set_root_label(' Buffers')
    state.handle:render()
  end
end

local function schedule_rebuild()
  if state.scheduled then return end
  state.scheduled = true
  vim.schedule(rebuild)
end

function M.render(bufnr)
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { '' })
  vim.bo[bufnr].modifiable = false
end

local function collect_file_entries_under(path)
  local result = {}
  local function walk(p)
    local kids = state.children[p]
    if not kids then return end
    for _, e in ipairs(kids) do
      if e.is_dir then walk(e.path)
      else result[#result + 1] = e end
    end
  end
  walk(path)
  return result
end

function M.enable(bufnr)
  if state.handle then state.handle:destroy() end
  state.bufnr = bufnr
  state.cwd = vim.fn.getcwd()
  state.children = list.parse(collect_bufs(), state.cwd)

  state.handle = tree.new({
    bufnr = bufnr,
    root_path = state.cwd,
    root_label = ' Buffers',
    get_children = function(path) return state.children[path] end,
    initially_expanded = true,
    on_select = function(entry, action)
      local ok, view = pcall(require, 'a-side.view')
      if ok then vim.api.nvim_set_current_win(view.ensure_editor_win()) end
      if action == 'tab' then
        vim.cmd('tab sbuffer ' .. entry.bufnr)
      elseif action == 'vsplit' then
        vim.cmd('vert sbuffer ' .. entry.bufnr)
      elseif action == 'hsplit' then
        vim.cmd('sbuffer ' .. entry.bufnr)
      else
        vim.cmd('buffer ' .. entry.bufnr)
      end
    end,
    on_render = function()
      local ok, view = pcall(require, 'a-side.view')
      if ok then view.resize('buffers') end
      refresh_indicators.tick(state.bufnr)
    end,
  })

  state.augroup = vim.api.nvim_create_augroup('ASideBuffers', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufModifiedSet' }, {
    group = state.augroup,
    callback = schedule_rebuild,
  })

  vim.keymap.set('n', 'D', function()
    local entry = state.handle and state.handle:cursor_entry()
    if not entry or entry.path == state.cwd then return end
    local to_delete = entry.is_dir
      and collect_file_entries_under(entry.path)
      or { entry }
    if #to_delete == 0 then return end
    local modified = vim.tbl_filter(function(e) return vim.bo[e.bufnr].modified end, to_delete)
    if #modified > 0 then
      local msg = #to_delete == 1
        and 'Buffer has unsaved changes. Delete? [y/N] '
        or (#to_delete .. ' buffers (' .. #modified .. ' unsaved). Delete all? [y/N] ')
      vim.ui.input({ prompt = msg }, function(input)
        if input and input:lower() == 'y' then
          for _, e in ipairs(to_delete) do
            pcall(vim.api.nvim_buf_delete, e.bufnr, { force = true })
          end
        end
      end)
    else
      for _, e in ipairs(to_delete) do
        pcall(vim.api.nvim_buf_delete, e.bufnr, { force = false })
      end
    end
  end, { buffer = bufnr, nowait = true, silent = true })

  state.handle:render()
end

function M.cursor_path()
  if not state.handle then return nil end
  local entry = state.handle:cursor_entry()
  if not entry then return nil end
  if entry.is_dir then return entry.path end
  return entry.path:match('^(.*)/[^/]+$')
end

function M.disable()
  if state.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
    state.augroup = nil
  end
  if state.handle then
    state.handle:destroy()
    state.handle = nil
  end
  if state.bufnr then
    pcall(vim.keymap.del, 'n', 'D', { buffer = state.bufnr })
  end
  state.bufnr = nil
  state.children = {}
  state.cwd = nil
  state.scheduled = false
end

return M
