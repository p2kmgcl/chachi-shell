return {
  "echasnovski/mini.animate",
  event = "BufReadPost",
  version = "*",
  config = function()
    require("mini.animate").setup()
  end,
}
