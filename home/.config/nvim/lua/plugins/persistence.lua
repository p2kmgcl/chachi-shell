return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore session from current dir",
    },
    {
      "<leader>ql",
      function()
        require("persistence").select()
      end,
      desc = "List sessions",
    },
  },
}
