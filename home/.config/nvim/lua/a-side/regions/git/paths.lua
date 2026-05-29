local M = {}

local function map_codes(x, y)
  local both = x .. y
  if both == '??' then return { 'untracked' } end
  if both == '!!' then return { 'ignored' } end
  if both == 'DD' or both == 'AA'
      or both == 'AU' or both == 'UA'
      or both == 'DU' or both == 'UD' or both == 'UU' then
    return { 'conflicted' }
  end
  local anns = {}
  if x == 'M' then anns[#anns + 1] = 'index_modified'
  elseif x == 'A' then anns[#anns + 1] = 'index_added'
  elseif x == 'D' then anns[#anns + 1] = 'index_deleted'
  elseif x == 'R' then anns[#anns + 1] = 'index_renamed'
  elseif x == 'C' then anns[#anns + 1] = 'index_copied'
  elseif x == 'T' then anns[#anns + 1] = 'index_typechange'
  end
  if y == 'M' then anns[#anns + 1] = 'worktree_modified'
  elseif y == 'D' then anns[#anns + 1] = 'worktree_deleted'
  elseif y == 'T' then anns[#anns + 1] = 'worktree_typechange'
  end
  return anns
end

local function split_segments(path)
  local segs = {}
  for s in path:gmatch('[^/]+') do segs[#segs + 1] = s end
  return segs
end

function M.parse(lines, toplevel)
  local children = { [toplevel] = {} }
  local seen_dir = { [toplevel] = true }
  local seen_entry = {}

  local function ensure_dir_chain(rel_segs)
    local parent = toplevel
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

  local function add_entry(rel_path, anns)
    local is_dir = rel_path:sub(-1) == '/'
    if is_dir then rel_path = rel_path:sub(1, -2) end
    local segs = split_segments(rel_path)
    if #segs == 0 then return end
    local name = segs[#segs]
    local parent_segs = {}
    for i = 1, #segs - 1 do parent_segs[i] = segs[i] end
    local parent = ensure_dir_chain(parent_segs)
    local key = parent .. '\0' .. name
    if seen_entry[key] then return end
    seen_entry[key] = true
    local full = parent .. '/' .. name
    if is_dir then
      seen_dir[full] = true
      children[full] = children[full] or {}
    end
    children[parent] = children[parent] or {}
    children[parent][#children[parent] + 1] = {
      name = name, path = full, is_dir = is_dir, annotations = anns,
    }
  end

  for _, line in ipairs(lines) do
    if #line >= 4 then
      local x = line:sub(1, 1)
      local y = line:sub(2, 2)
      local rest = line:sub(4)
      local path
      if (x == 'R' or x == 'C') and rest:find(' %-> ') then
        path = rest:match('.* %-> (.+)$')
      else
        path = rest
      end
      if path and path ~= '' then
        add_entry(path, map_codes(x, y))
      end
    end
  end

  for _, list in pairs(children) do
    table.sort(list, function(a, b)
      if a.is_dir ~= b.is_dir then return a.is_dir end
      return a.name:lower() < b.name:lower()
    end)
  end

  return children
end

return M
