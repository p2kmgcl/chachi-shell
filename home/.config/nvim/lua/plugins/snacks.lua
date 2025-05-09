return {
  "folke/snacks.nvim",
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
            },
          },
        },
      },
    },
  },
}
