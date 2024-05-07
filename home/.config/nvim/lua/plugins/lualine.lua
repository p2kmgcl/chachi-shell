return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        theme = "auto",
        icons_enabled = true,
        sections = {},
      }
    end,
  },
}
