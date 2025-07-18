return {
  "Exafunction/windsurf.vim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("codeium").setup({})
  end,
}
