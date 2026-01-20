return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local get_mini_files_path = require("helpers.get-mini-files-path")

        grug.open({
          transient = true,
          prefills = {
            paths = get_mini_files_path({ close_explorer = true }),
            flags = "--hidden",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
