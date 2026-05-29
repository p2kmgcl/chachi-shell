local M = {}

function M.new()
  local handles = {}

  local instance = {}

  function instance.start(path, on_dirty)
    if handles[path] then return end
    local h = vim.uv.new_fs_event()
    if not h then return end
    handles[path] = h
    local on_event
    on_event = function()
      h:stop()
      pcall(h.start, h, path, {}, on_event)
      vim.schedule(function() on_dirty(path) end)
    end
    pcall(h.start, h, path, {}, on_event)
  end

  function instance.stop(path)
    local h = handles[path]
    if not h then return end
    h:stop()
    if not h:is_closing() then h:close() end
    handles[path] = nil
  end

  function instance.stop_all()
    for path, h in pairs(handles) do
      h:stop()
      if not h:is_closing() then h:close() end
      handles[path] = nil
    end
  end

  return instance
end

return M
