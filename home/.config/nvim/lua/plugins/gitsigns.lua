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
  keys = {
    {
      "<leader>gb",
      function()
        require("gitsigns").blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gB",
      function()
        require("gitsigns").blame()
      end,
      desc = "Git Blame File",
    },
    {
      "<leader>gd",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Git Diff Hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Previous hunk",
    },
    {
      "]h",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Next hunk",
    },
    {
      "<leader>gH",
      function()
        local gs = require("gitsigns")
        gs.toggle_deleted()
        gs.toggle_word_diff()
      end,
      desc = "Toggle Inline Hunks",
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
