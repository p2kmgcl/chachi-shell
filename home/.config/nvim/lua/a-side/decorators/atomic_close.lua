local M = {}

local autocmd_id

function M.enable(winids, on_close)
  local aside = {}
  for _, winid in ipairs(winids) do
    aside[winid] = true
  end

  if autocmd_id then
    pcall(vim.api.nvim_del_autocmd, autocmd_id)
  end

  autocmd_id = vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      local closed = tonumber(args.match)
      if aside[closed] then
        on_close()
      end
    end,
  })
end

function M.disable()
  if autocmd_id then
    pcall(vim.api.nvim_del_autocmd, autocmd_id)
    autocmd_id = nil
  end
end

return M
