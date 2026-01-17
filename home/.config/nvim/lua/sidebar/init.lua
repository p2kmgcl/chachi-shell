local M = {}

function M.setup()
  local buffers = require("sidebar.buffers")
  local git = require("sidebar.git")

  vim.api.nvim_create_user_command("SidebarBuffers", buffers.open, {})
  vim.api.nvim_create_user_command("SidebarGit", git.open, {})

  local group = vim.api.nvim_create_augroup("Sidebar", { clear = true })
  local debounce_timer = nil

  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
    group = group,
    callback = function()
      if debounce_timer then debounce_timer:stop() end
      debounce_timer = vim.defer_fn(buffers.refresh, 50)
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function() vim.defer_fn(git.refresh, 100) end,
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      buffers.refresh()
      git.refresh()
    end,
  })
end

return M
