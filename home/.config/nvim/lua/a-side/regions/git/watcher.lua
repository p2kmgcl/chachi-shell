local M = {}

local DEBOUNCE_MS = 150

-- Prefixes under .git/ that never affect `git status` output.
-- fsmonitor--daemon/cookies/ is written on every git status call when the
-- built-in fsmonitor daemon is active, which would otherwise cause a feedback loop.
local IGNORE_PREFIXES = {
  'fsmonitor--daemon/',
  'objects/',
  'logs/',
}

local function is_relevant(filename)
  if not filename then return true end
  for _, prefix in ipairs(IGNORE_PREFIXES) do
    if filename:sub(1, #prefix) == prefix then return false end
  end
  return true
end

function M.start(gitdir, on_trigger)
  local handle = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()

  if not handle or not timer then return end

  local function schedule_trigger()
    timer:stop()
    timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(on_trigger))
  end

  handle:start(gitdir, { recursive = true }, function(err, filename, events)
    if is_relevant(filename) then schedule_trigger() end
  end)

  return {
    stop = function()
      timer:stop()
      if not timer:is_closing() then timer:close() end
      handle:stop()
      if not handle:is_closing() then handle:close() end
    end,
  }
end

return M
