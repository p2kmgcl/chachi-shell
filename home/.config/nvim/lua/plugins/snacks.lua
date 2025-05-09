return {
  "folke/snacks.nvim",
  opts = {
    explorer = {},
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
