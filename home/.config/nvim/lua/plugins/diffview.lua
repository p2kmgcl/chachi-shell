return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  keys = {
    {
      "<leader>gD",
      function()
        require("diffview").open()
      end,
      desc = "DiffView",
    },
  },
}
