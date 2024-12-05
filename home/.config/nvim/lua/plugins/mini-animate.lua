return {
  "echasnovski/mini.animate",
  event = "BufReadPost",
  config = function()
    require("mini.animate").setup()
  end,
}
