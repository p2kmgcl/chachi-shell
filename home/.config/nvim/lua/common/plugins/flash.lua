return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
  opts = function()
    vim.api.nvim_set_hl(0, "FlashMatch", { underline = true })
    vim.api.nvim_set_hl(0, "FlashCurrent", { underline = true, bold = true })
    vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ffff00", fg = "#000000", bold = true })
  end,
}
