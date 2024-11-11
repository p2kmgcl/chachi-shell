return {
  "echasnovski/mini.pairs",
  event = "BufReadPost",
  version = "0.14.0",
  config = function()
    require("mini.pairs").setup()
  end,
}
