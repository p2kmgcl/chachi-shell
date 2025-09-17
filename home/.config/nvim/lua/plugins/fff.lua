return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require('fff.download').download_or_build_binary()
  end,
  lazy = false,
  opts = {
    debug = {
      enabled = true,
      show_scores = true,
    }
  },
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
          fff.find_files_in_dir(vim.fn.getcwd(-1, -1))
        end
      end,
      desc = "Open file picker",
    },
  },
}
