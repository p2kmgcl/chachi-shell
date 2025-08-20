return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local getMiniFilesPath = require("helpers.get-mini-files-path")

        grug.open({
          transient = true,
          prefills = { paths = getMiniFilesPath(), flags = "--hidden" },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
