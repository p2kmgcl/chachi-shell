local M = {}

local WATCHED = { "index", "HEAD", "FETCH_HEAD" }
local DEBOUNCE_MS = 500

function M.start(gitdir, on_trigger)
  local handles = {}
  local timers = {}

  for _, name in ipairs(WATCHED) do
    local path = gitdir .. "/" .. name
    local handle = vim.uv.new_fs_event()
    local timer = vim.uv.new_timer()
    local last_stat = vim.uv.fs_stat(path)

    if timer == nil or handle == nil then
      return
    end

    local function trigger()
      local stat = vim.uv.fs_stat(path)
      if stat and last_stat and stat.mtime.sec ~= last_stat.mtime.sec then
        last_stat = stat
        on_trigger()
      end
    end

    local function schedule_trigger()
      timer:stop()
      timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(trigger))
    end

    handles[#handles + 1] = handle
    timers[#timers + 1] = timer
    handle:start(path, {}, schedule_trigger)
  end

  return {
    stop = function()
      for _, timer in ipairs(timers) do
        timer:stop()
        if not timer:is_closing() then
          timer:close()
        end
      end
      for _, handler in ipairs(handles) do
        handler:stop()
        if not handler:is_closing() then
          handler:close()
        end
      end
    end,
  }
end

return M
