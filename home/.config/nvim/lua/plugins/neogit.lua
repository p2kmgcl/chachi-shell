return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = true,
  config = true,
  keys = {
    {
      "<leader>gc",
      function()
        vim.cmd("Neogit commit")
      end,
      mode = "",
      desc = "[G]it [c]ommit",
    },
    {
      "<leader>gs",
      function()
        vim.cmd("Neogit")
      end,
      mode = "",
      desc = "[G]it [s]tatus",
    },
  },
}
