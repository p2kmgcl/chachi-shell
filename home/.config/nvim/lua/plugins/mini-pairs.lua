return {
  "echasnovski/mini.pairs",
  event = "BufReadPost",
  config = function()
    require("mini.pairs").setup()
  end,
}
