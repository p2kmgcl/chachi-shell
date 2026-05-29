local M = {}

function M.list_sync(dir)
  local items = {}
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return items end
  while true do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local is_link = t == 'link'
    local is_dir = (t == 'directory') and not is_link
    items[#items + 1] = { name = name, is_dir = is_dir, is_link = is_link }
  end
  table.sort(items, function(a, b)
    if a.is_dir ~= b.is_dir then return a.is_dir end
    return a.name:lower() < b.name:lower()
  end)
  return items
end

function M.filter_async(dir, items, callback)
  if #items == 0 then
    vim.schedule(function() callback(items) end)
    return
  end
  local names = {}
  for _, it in ipairs(items) do names[#names + 1] = it.name end
  local stdin = table.concat(names, '\n') .. '\n'
  vim.system(
    { 'git', '-C', dir, 'check-ignore', '--stdin' },
    { text = true, stdin = stdin },
    function(out)
      vim.schedule(function()
        if out.code == 128 then
          callback(items)
          return
        end
        local ignored = {}
        for _, line in ipairs(vim.split(out.stdout or '', '\n', { plain = true })) do
          if line ~= '' then ignored[line] = true end
        end
        local filtered = {}
        for _, it in ipairs(items) do
          if not ignored[it.name] then filtered[#filtered + 1] = it end
        end
        callback(filtered)
      end)
    end
  )
end

return M
