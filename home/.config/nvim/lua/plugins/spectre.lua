return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  keys = {
    {
      "<leader>sR",
      function()
        require("spectre").open()
      end,
      desc = "[S]earch and [R]eplace",
    },
  },
}
