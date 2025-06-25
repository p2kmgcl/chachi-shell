return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
  },
  opts = {
    indent = {
      enabled = false,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          follow = true,
          layout = {
            preset = "sidebar",
            preview = false,
            layout = {
              position = "right",
              width = 80,
            },
          },
        },
      },
    },
  },
}
