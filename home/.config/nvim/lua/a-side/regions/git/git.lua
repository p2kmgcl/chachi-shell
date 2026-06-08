local status = require('a-side.regions.git.status')
local watcher = require('a-side.regions.git.watcher')
local paths = require('a-side.regions.git.paths')
local tree = require('a-side.ui.tree.tree')
local refresh_indicators = require('a-side.decorators.refresh_indicators')

local M = {
  name = 'git',
  filetype = 'aside-git',
}

local function branch_name(line)
  if line == '' then return nil end
  return line:match("^## (.-)%.%.%.")
    or line:match("^## No commits yet on (%S+)")
    or line:match("^## (%S+)")
end

local POLL_MS = 10000

local state = {
  bufnr = nil,
  toplevel = nil,
  gitdir = nil,
  watcher = nil,
  poll_timer = nil,
  running = false,
  dirty = false,
  handle = nil,
  children = {},
  branch_line = '',
}

local function write_flat(lines)
  if not (state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr)) then return end
  vim.bo[state.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.bo[state.bufnr].modifiable = false
  local ok, view = pcall(require, 'a-side.view')
  if ok then view.resize('git') end
end

local function ensure_handle()
  if state.handle or not (state.bufnr and state.toplevel) then return end
  state.handle = tree.new({
    bufnr = state.bufnr,
    root_path = state.toplevel,
    root_label = " Git・" .. (branch_name(state.branch_line) or state.toplevel),
    get_children = function(path) return state.children[path] end,
    initially_expanded = true,
    on_select = function(entry, action)
      local cmds = { edit = 'edit', vsplit = 'vsplit', hsplit = 'split', tab = 'tabedit' }
      local ok, view = pcall(require, 'a-side.view')
      if ok then vim.api.nvim_set_current_win(view.ensure_editor_win()) end
      vim.cmd((cmds[action] or 'edit') .. ' ' .. vim.fn.fnameescape(entry.path))
    end,
    on_render = function()
      local ok, view = pcall(require, 'a-side.view')
      if ok then view.resize('git') end
      refresh_indicators.tick(state.bufnr)
    end,
  })
end

local function collect_files_under(path)
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

local function is_fully_staged(entry)
  local has_index, has_worktree = false, false
  for _, ann in ipairs(entry.annotations or {}) do
    if ann:sub(1, 6) == 'index_' then has_index = true end
    if ann:sub(1, 9) == 'worktree_' or ann == 'untracked' then has_worktree = true end
  end
  return has_index and not has_worktree
end

local function git_run(args)
  if not state.toplevel then return end
  vim.system(vim.list_extend({ 'git', '-C', state.toplevel }, args), {}, function() end)
end

local function discard_entry(entry)
  local is_untracked = vim.tbl_contains(entry.annotations or {}, 'untracked')
  if is_untracked then
    vim.fn.delete(entry.path)
  else
    git_run({ 'restore', '--source=HEAD', '--staged', '--worktree', entry.path })
  end
end

local function run()
  if state.running then
    state.dirty = true
    return
  end
  if not state.toplevel then return end
  state.running = true
  status.run(state.toplevel, function(result)
    state.running = false
    if not state.bufnr then return end
    if not result.ok then
      if state.handle then state.handle:destroy(); state.handle = nil end
      write_flat({ 'git error: ' .. (result.err or '') })
      if state.dirty then state.dirty = false; run() end
      return
    end

    local branch_line = ''
    local status_lines = {}
    for _, line in ipairs(result.lines) do
      if line:sub(1, 2) == '##' then
        branch_line = line
      else
        status_lines[#status_lines + 1] = line
      end
    end
    state.branch_line = branch_line
    state.children = paths.parse(status_lines, state.toplevel)

    ensure_handle()
    if state.handle then
      state.handle:set_root_label(" Git・" .. (branch_name(branch_line) or state.toplevel))
      state.handle:render()
    else
      write_flat({ branch_line })
      refresh_indicators.tick(state.bufnr)
    end

    if state.dirty then
      state.dirty = false
      run()
    end
  end)
end

function M.render(bufnr)
  state.bufnr = bufnr
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'loading…' })
  vim.bo[bufnr].modifiable = false
end

function M.enable(bufnr)
  state.bufnr = bufnr
  state.children = {}
  state.branch_line = ''
  if state.handle then state.handle:destroy(); state.handle = nil end
  write_flat({ 'loading…' })

  local cwd = vim.fn.getcwd()
  status.resolve(cwd, function(info)
    if not state.bufnr then return end
    if not info then
      state.toplevel = nil
      state.gitdir = nil
      write_flat({ 'not a git repo' })
      return
    end
    state.toplevel = info.toplevel
    state.gitdir = info.gitdir
    state.watcher = watcher.start(state.gitdir, run)
    state.poll_timer = vim.uv.new_timer()
    state.poll_timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(run))
    run()
  end)

  vim.keymap.set('n', 'S', function()
    if not state.toplevel or not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry or entry.path == state.toplevel then return end
    if entry.is_dir then
      local files = collect_files_under(entry.path)
      local all_staged = #files > 0 and vim.tbl_isempty(vim.tbl_filter(function(e)
        return not is_fully_staged(e)
      end, files))
      if all_staged then
        git_run({ 'restore', '--staged', entry.path })
      else
        git_run({ 'add', entry.path })
      end
    else
      if is_fully_staged(entry) then
        git_run({ 'restore', '--staged', entry.path })
      else
        git_run({ 'add', entry.path })
      end
    end
  end, { buffer = bufnr, nowait = true, silent = true })

  vim.keymap.set('n', 'X', function()
    if not state.toplevel or not state.handle then return end
    local entry = state.handle:cursor_entry()
    if not entry or entry.path == state.toplevel then return end
    local files = entry.is_dir and collect_files_under(entry.path) or { entry }
    if #files == 0 then return end
    local label = entry.is_dir
      and ('Discard all changes under ' .. entry.name .. '/? (' .. #files .. ' files) [y/N] ')
      or ('Discard changes to ' .. entry.name .. '? [y/N] ')
    vim.ui.input({ prompt = label }, function(input)
      if input and input:lower() == 'y' then
        for _, f in ipairs(files) do discard_entry(f) end
      end
    end)
  end, { buffer = bufnr, nowait = true, silent = true })
end

function M.cursor_path()
  if not state.handle then return nil end
  local entry = state.handle:cursor_entry()
  if not entry then return nil end
  if entry.is_dir then return entry.path end
  return entry.path:match('^(.*)/[^/]+$')
end

function M.disable()
  if state.poll_timer then
    state.poll_timer:stop()
    if not state.poll_timer:is_closing() then state.poll_timer:close() end
    state.poll_timer = nil
  end
  if state.watcher then
    state.watcher.stop()
    state.watcher = nil
  end
  if state.handle then
    state.handle:destroy()
    state.handle = nil
  end
  if state.bufnr then
    pcall(vim.keymap.del, 'n', 'S', { buffer = state.bufnr })
    pcall(vim.keymap.del, 'n', 'X', { buffer = state.bufnr })
  end
  state.running = false
  state.dirty = false
  state.toplevel = nil
  state.gitdir = nil
  state.bufnr = nil
  state.children = {}
  state.branch_line = ''
end

return M
