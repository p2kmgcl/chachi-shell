return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local get_explorer_path = require("helpers.get-explorer-path")

        grug.open({
          transient = true,
          prefills = {
            paths = get_explorer_path(),
            flags = "--hidden",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
