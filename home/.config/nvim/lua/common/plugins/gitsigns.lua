return {
  "lewis6991/gitsigns.nvim",
  opts = {
    update_debounce = 10000,
    watch_gitdir = {
      interval = 0,
      follow_files = false,
    },
    max_file_length = 40000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    local group = vim.api.nvim_create_augroup("GitsignsRefresh", { clear = true })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })
  end,
}
