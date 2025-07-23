return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    watch_gitdir = {
      interval = 0,
      follow_files = false,
    },
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)

    local group = vim.api.nvim_create_augroup("GitsignsRefresh", { clear = true })
    vim.api.nvim_create_autocmd("InsertLeave", { group = group, callback = gitsigns.refresh })
    vim.api.nvim_create_autocmd("BufWritePost", { group = group, callback = gitsigns.refresh })
    vim.api.nvim_create_autocmd("BufEnter", { group = group, callback = gitsigns.refresh })
    vim.api.nvim_create_autocmd("FocusGained", { group = group, callback = gitsigns.refresh })
  end,
}
