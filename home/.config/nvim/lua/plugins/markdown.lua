return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  opts = {
    quote = {
      breakindent = true,
      repeat_linebreak = true,
    },
  },
}
