return {
  "greggh/claude-code.nvim",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("claude-code").setup({
      window = {
        position = "vertical",
        enter_insert = true,
      },
    })
  end,
}
