return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {},
  keys = {
    {
      "<leader><space>",
      function()
        local fff = require("fff")
        local getMiniFilesPath = require("helpers.get-mini-files-path")
        local miniFilesPath = getMiniFilesPath()

        if miniFilesPath then
          fff.find_files_in_dir(miniFilesPath)
        else
          fff.find_files()
        end
      end,
      desc = "Open file picker",
    },
  },
}
