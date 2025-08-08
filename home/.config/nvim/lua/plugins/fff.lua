return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {},
  keys = {
    {
      "<leader><space>",
      function()
        require("fff").find_files()
      end,
      desc = "Open file picker",
    },
  },
}
