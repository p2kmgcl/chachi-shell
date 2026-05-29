local M = {}

local function is_under(cwd, abspath)
  if cwd == '' or abspath == '' then return false end
  return abspath == cwd or abspath:sub(1, #cwd + 1) == cwd .. '/'
end

local function split_segments(path)
  local segs = {}
  for s in path:gmatch('[^/]+') do segs[#segs + 1] = s end
  return segs
end

function M.parse(bufs, cwd)
  local children = { [cwd] = {} }
  local seen_dir = { [cwd] = true }
  local seen_entry = {}

  local function ensure_dir_chain(rel_segs)
    local parent = cwd
    for i = 1, #rel_segs do
      local name = rel_segs[i]
      local full = parent .. '/' .. name
      local key = parent .. '\0' .. name
      if not seen_entry[key] then
        seen_entry[key] = true
        children[parent] = children[parent] or {}
        children[parent][#children[parent] + 1] = {
          name = name, path = full, is_dir = true, annotations = {},
        }
      end
      if not seen_dir[full] then
        seen_dir[full] = true
        children[full] = children[full] or {}
      end
      parent = full
    end
    return parent
  end

  local externals = {}

  for _, b in ipairs(bufs) do
    local anns = b.modified and { 'buffer_modified' } or {}
    if b.name == '' then
      externals[#externals + 1] = {
        name = '[No Name]',
        path = 'noname:' .. b.bufnr,
        is_dir = false,
        annotations = anns,
        bufnr = b.bufnr,
        _sort = '\255' .. string.format('%010d', b.bufnr),
      }
    elseif is_under(cwd, b.name) and b.name ~= cwd then
      local rel = b.name:sub(#cwd + 2)
      local segs = split_segments(rel)
      local name = segs[#segs]
      local parent_segs = {}
      for i = 1, #segs - 1 do parent_segs[i] = segs[i] end
      local parent = ensure_dir_chain(parent_segs)
      local key = parent .. '\0' .. name
      if not seen_entry[key] then
        seen_entry[key] = true
        children[parent] = children[parent] or {}
        children[parent][#children[parent] + 1] = {
          name = name,
          path = parent .. '/' .. name,
          is_dir = false,
          annotations = anns,
          bufnr = b.bufnr,
        }
      end
    else
      externals[#externals + 1] = {
        name = b.name,
        path = b.name,
        is_dir = false,
        annotations = anns,
        bufnr = b.bufnr,
        _sort = b.name:lower(),
      }
    end
  end

  for _, list in pairs(children) do
    table.sort(list, function(a, b)
      if a.is_dir ~= b.is_dir then return a.is_dir end
      return a.name:lower() < b.name:lower()
    end)
  end

  table.sort(externals, function(a, b) return a._sort < b._sort end)
  for _, e in ipairs(externals) do
    e._sort = nil
    children[cwd][#children[cwd] + 1] = e
  end

  return children
end

return M
