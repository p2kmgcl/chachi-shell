-- NOTE: Highlight todo, notes, etc in comments
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { signs = false },
  keys = {
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous [t]odo",
    },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next [t]odo",
    },
  },
}
