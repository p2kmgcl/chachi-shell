return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
  opts = function()
    vim.api.nvim_set_hl(0, "FlashMatch", { underline = true })
    vim.api.nvim_set_hl(0, "FlashCurrent", { underline = true, bold = true })
    vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ffff00", fg = "#000000", bold = true })
  end,
}
