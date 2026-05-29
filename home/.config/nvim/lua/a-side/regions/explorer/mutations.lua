local M = {}

-- LSP helpers ----------------------------------------------------------------

local function path_to_uri(path)
  return 'file://' .. path
end

local function lsp_notify(method, params)
  for _, client in ipairs(vim.lsp.get_clients()) do
    client.notify(method, params)
  end
end

function M.lsp_will_rename(old_path, new_path)
  lsp_notify('workspace/willRenameFiles', {
    files = { { oldUri = path_to_uri(old_path), newUri = path_to_uri(new_path) } },
  })
end

function M.lsp_did_rename(old_path, new_path)
  lsp_notify('workspace/didRenameFiles', {
    files = { { oldUri = path_to_uri(old_path), newUri = path_to_uri(new_path) } },
  })
end

function M.lsp_did_delete(path)
  lsp_notify('workspace/didDeleteFiles', {
    files = { { uri = path_to_uri(path) } },
  })
end

function M.lsp_did_create(path)
  lsp_notify('workspace/didCreateFiles', {
    files = { { uri = path_to_uri(path) } },
  })
end

-- Buffer helpers -------------------------------------------------------------

function M.wipe_buffers_under(path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == path or name:sub(1, #path + 1) == path .. '/' then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end
end

function M.rename_buffer(old_path, new_path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bufnr) == old_path then
      pcall(vim.api.nvim_buf_set_name, bufnr, new_path)
    end
  end
end

-- Filesystem helpers ---------------------------------------------------------

-- Count files under a directory (synchronous, for delete prompt).
local function count_files(path)
  local n = 0
  local handle = vim.uv.fs_scandir(path)
  if not handle then return 0 end
  while true do
    local name, ftype = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if ftype == 'directory' then
      n = n + count_files(path .. '/' .. name)
    else
      n = n + 1
    end
  end
  return n
end

-- Recursively copy src to dest (async).
local function copy_recursive(src, dest, on_done)
  local stat = vim.uv.fs_stat(src)
  if not stat then on_done('stat failed: ' .. src) return end
  if stat.type == 'directory' then
    if vim.fn.mkdir(dest, 'p') == 0 then
      on_done('mkdir failed: ' .. dest) return
    end
    local handle = vim.uv.fs_scandir(src)
    if not handle then on_done('scandir failed: ' .. src) return end
    local items = {}
    while true do
      local name, ftype = vim.uv.fs_scandir_next(handle)
      if not name then break end
      items[#items + 1] = { name = name, ftype = ftype }
    end
    local i = 0
    local function next_item()
      i = i + 1
      if i > #items then on_done(nil) return end
      local item = items[i]
      copy_recursive(src .. '/' .. item.name, dest .. '/' .. item.name, function(err)
        if err then on_done(err) return end
        next_item()
      end)
    end
    next_item()
  else
    vim.uv.fs_copyfile(src, dest, function(err)
      vim.schedule(function() on_done(err and tostring(err) or nil) end)
    end)
  end
end

-- Move src to dest. Tries fs_rename first; falls back to copy+delete on EXDEV.
local function move_path(src, dest, on_done)
  vim.uv.fs_rename(src, dest, function(err)
    if not err then
      vim.schedule(function() on_done(nil) end)
      return
    end
    copy_recursive(src, dest, function(copy_err)
      if copy_err then on_done(copy_err) return end
      vim.fn.delete(src, 'rf')
      on_done(nil)
    end)
  end)
end

-- Conflict-safe destination name prompt.
-- If dest already exists, prompts with a suggested alternate name.
-- Calls on_done(resolved_dest) on success, on_done(nil) on cancel.
local function resolve_dest(dest, on_done)
  if not vim.uv.fs_stat(dest) then
    on_done(dest) return
  end
  local parent = dest:match('^(.*)/[^/]+$') or ''
  local name   = dest:match('[^/]+$') or dest
  -- strip trailing slash from directory names
  name = name:gsub('/$', '')
  local stem = name:match('^(.+)%.([^%.]+)$')
  local ext  = name:match('%.([^%.]+)$')
  local suggested
  if stem and ext then
    suggested = parent .. '/' .. stem .. '.copy.' .. ext
  else
    suggested = parent .. '/' .. name .. '.copy'
  end
  vim.ui.input({ prompt = 'Name conflict — new name: ', default = suggested:match('[^/]+$') }, function(input)
    if not input or input == '' then on_done(nil) return end
    on_done(parent .. '/' .. input)
  end)
end

-- Public operations ----------------------------------------------------------

-- Prompt for a name and create a file or directory under dest_dir.
-- Trailing '/' in the entered name creates a directory.
-- Calls on_done(created_path) on success, on_done(nil) on cancel/error.
function M.create(dest_dir, on_done)
  vim.ui.input({ prompt = 'New name (trailing / = dir): ' }, function(input)
    if not input or input == '' then on_done(nil) return end
    local is_dir = input:sub(-1) == '/'
    local name = is_dir and input:sub(1, -2) or input
    if name == '' then on_done(nil) return end
    local path = dest_dir .. '/' .. name
    if is_dir then
      if vim.fn.mkdir(path, 'p') == 0 then
        vim.notify('a-side: mkdir failed: ' .. path, vim.log.levels.ERROR)
        on_done(nil) return
      end
    else
      local f, err = io.open(path, 'wx')
      if not f then
        vim.notify('a-side: create failed: ' .. (err or path), vim.log.levels.ERROR)
        on_done(nil) return
      end
      f:close()
    end
    M.lsp_did_create(path)
    on_done(path)
  end)
end

-- Prompt to rename entry. Pre-fills with entry's basename.
-- Calls on_done(new_path) on success, on_done(nil) on cancel/no-op.
function M.rename(entry, on_done)
  local parent = entry.path:match('^(.*)/[^/]+$') or ''
  local basename = entry.path:match('[^/]+$') or entry.path
  vim.ui.input({ prompt = 'Rename: ', default = basename }, function(input)
    if not input or input == '' or input == basename then on_done(nil) return end
    local new_path = parent .. '/' .. input
    M.lsp_will_rename(entry.path, new_path)
    local ok = vim.uv.fs_rename(entry.path, new_path)
    -- fs_rename is sync when called without callback
    if ok then
      M.rename_buffer(entry.path, new_path)
      M.lsp_did_rename(entry.path, new_path)
      on_done(new_path)
    else
      vim.notify('a-side: rename failed', vim.log.levels.ERROR)
      on_done(nil)
    end
  end)
end

-- Confirm and hard-delete entry from disk.
-- Calls on_done(true) on success, on_done(false) on cancel.
function M.delete(entry, on_done)
  local label
  if entry.is_dir then
    local n = count_files(entry.path)
    label = entry.name .. '/ (' .. n .. ' file' .. (n == 1 and '' or 's') .. ')'
  else
    label = entry.name
  end
  local choice = vim.fn.confirm('Delete ' .. label .. '?', '&Yes\n&No', 2)
  if choice ~= 1 then on_done(false) return end
  vim.fn.delete(entry.path, 'rf')
  M.wipe_buffers_under(entry.path)
  M.lsp_did_delete(entry.path)
  on_done(true)
end

-- Copy src_path to dest_dir, resolving name conflicts interactively.
-- Calls on_done(new_path) on success, on_done(nil) on cancel/error.
function M.paste_copy(src_path, dest_dir, on_done)
  local name = src_path:match('[^/]+$') or src_path
  local dest = dest_dir .. '/' .. name
  resolve_dest(dest, function(resolved)
    if not resolved then on_done(nil) return end
    copy_recursive(src_path, resolved, function(err)
      if err then
        vim.notify('a-side: copy failed: ' .. err, vim.log.levels.ERROR)
        on_done(nil) return
      end
      M.lsp_did_create(resolved)
      on_done(resolved)
    end)
  end)
end

-- Move src_path to dest_dir, resolving name conflicts interactively.
-- Sends LSP rename notifications.
-- Calls on_done(new_path) on success, on_done(nil) on cancel/error.
function M.paste_move(src_path, dest_dir, on_done)
  local name = src_path:match('[^/]+$') or src_path
  local dest = dest_dir .. '/' .. name
  resolve_dest(dest, function(resolved)
    if not resolved then on_done(nil) return end
    M.lsp_will_rename(src_path, resolved)
    move_path(src_path, resolved, function(err)
      if err then
        vim.notify('a-side: move failed: ' .. err, vim.log.levels.ERROR)
        on_done(nil) return
      end
      M.rename_buffer(src_path, resolved)
      M.lsp_did_rename(src_path, resolved)
      on_done(resolved)
    end)
  end)
end

return M
