local M = {}

local autocmd_id

function M.enable(winids)
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
        return
      end
      local skip = { [closed] = true }
      for winid in pairs(aside) do
        skip[winid] = true
      end
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if not skip[w] then
          return
        end
      end
      if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd("tabclose")
      else
        vim.cmd("qa")
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
