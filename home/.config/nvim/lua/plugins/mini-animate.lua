return {
  "echasnovski/mini.animate",
  event = "BufReadPost",
  version = "0.14.0",
  config = function()
    require("mini.animate").setup()
  end,
}
