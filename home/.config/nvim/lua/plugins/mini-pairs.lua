return {
  "echasnovski/mini.pairs",
  event = "BufReadPost",
  version = "*",
  config = function()
    require("mini.pairs").setup()
  end,
}
