local M = {}

local DEBOUNCE_MS = 150

function M.start(gitdir, on_trigger)
  local handle = vim.uv.new_fs_event()
  local timer = vim.uv.new_timer()

  if not handle or not timer then return end

  local function schedule_trigger()
    timer:stop()
    timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(on_trigger))
  end

  handle:start(gitdir, {}, schedule_trigger)

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
