-- NOTE: Highlight todo, notes, etc in comments
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost" },
  dependencies = { { "nvim-lua/plenary.nvim" } },
  opts = {
    signs = false,
  },
  keys = {
    {
      "[T",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous [T]odo",
    },
    {
      "]T",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next [T]odo",
    },
  },
}
