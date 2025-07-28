return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        grug.open({
          transient = true,
          prefills = { flags = "--hidden" },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
