return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  lazy = false,
  opts = {},
  keys = {
    {
      "<leader><space>",
      function()
        local fff = require("fff")
        local get_mini_files_path = require("helpers.get-mini-files-path")
        local mini_files_path = get_mini_files_path({ close_explorer = true })

        if mini_files_path then
          fff.find_files_in_dir(mini_files_path)
        else
          fff.find_files()
        end
      end,
      desc = "Open file picker",
    },
  },
}
