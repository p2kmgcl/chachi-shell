return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  keys = {
    {
      "<leader>fr",
      function()
        require("spectre").open()
      end,
      desc = "[F]ind and [R]eplace",
    },
  },
}
