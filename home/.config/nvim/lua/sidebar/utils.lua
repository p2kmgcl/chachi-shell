local M = {}

M.buffers = {}
M.filetypes = { buffers = "sidebar_buffers", git = "sidebar_git" }

local git_root_cache = nil

function M.get_icon(name, category)
  local ok, icons = pcall(require, "mini.icons")
  if ok then return icons.get(category, name) end
  return "", "Normal"
end

function M.get_git_root()
  if git_root_cache then return git_root_cache end
  local obj = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if obj.code == 0 then
    git_root_cache = vim.trim(obj.stdout)
    return git_root_cache
  end
  return nil
end

function M.get_or_create_buffer(section)
  local buf = M.buffers[section]
  if buf and vim.api.nvim_buf_is_valid(buf) then return buf end
  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = M.filetypes[section]
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  M.buffers[section] = buf
  return buf
end

function M.show_buffer(buf)
  if #vim.fn.win_findbuf(buf) > 0 then return end
  vim.cmd.vsplit()
  vim.api.nvim_win_set_buf(0, buf)
end

function M.set_lines(buf, lines, highlights)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  local ns = vim.api.nvim_create_namespace("sidebar")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for _, hl in ipairs(highlights or {}) do
    pcall(vim.api.nvim_buf_add_highlight, buf, ns, hl.hl, hl.line, hl.col_start, hl.col_end)
  end
end

function M.get_relative_path(filepath)
  local root = M.get_git_root()
  if root and filepath:sub(1, #root) == root then
    return filepath:sub(#root + 2)
  end
  return filepath
end

function M.render_tree(items, get_line)
  local lines, entries, highlights = {}, {}, {}
  
  local tree = {}
  for _, item in ipairs(items) do
    local parts = vim.split(item.path, "/")
    local node = tree
    for i, part in ipairs(parts) do
      node[part] = node[part] or {}
      if i == #parts then node[part]._item = item end
      node = node[part]
    end
  end

  local function flatten_path(name, node)
    while true do
      local keys = {}
      for k in pairs(node) do if k ~= "_item" then keys[#keys + 1] = k end end
      if #keys == 1 and not node[keys[1]]._item then
        name = name .. "/" .. keys[1]
        node = node[keys[1]]
      else break end
    end
    return name, node
  end

  local function render_node(node, indent)
    local dirs, files = {}, {}
    for k, v in pairs(node) do
      if k ~= "_item" then
        if v._item then files[#files + 1] = { k = k, v = v }
        else dirs[#dirs + 1] = { k = k, v = v } end
      end
    end
    table.sort(dirs, function(a, b) return a.k < b.k end)
    table.sort(files, function(a, b) return a.k < b.k end)

    local pad = string.rep("  ", indent)
    for _, d in ipairs(dirs) do
      local name, final = flatten_path(d.k, d.v)
      local icon, hl = M.get_icon(name:match("[^/]+$") or name, "directory")
      lines[#lines + 1] = pad .. icon .. " " .. name
      entries[#entries + 1] = { is_dir = true }
      highlights[#highlights + 1] = { line = #lines - 1, col_start = #pad, col_end = #pad + #icon, hl = hl }
      highlights[#highlights + 1] = { line = #lines - 1, col_start = #pad + #icon + 1, col_end = -1, hl = "Directory" }
      render_node(final, indent + 1)
    end

    for _, f in ipairs(files) do
      local line, hls = get_line(f.v._item, pad)
      lines[#lines + 1] = line
      entries[#entries + 1] = f.v._item
      for _, h in ipairs(hls or {}) do
        h.line = #lines - 1
        highlights[#highlights + 1] = h
      end
    end
  end

  render_node(tree, 0)
  return lines, entries, highlights
end

return M
