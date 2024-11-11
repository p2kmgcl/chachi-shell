return {
  "nvim-neotest/neotest",
  version = "5.6.1",
  lazy = true,
  dependencies = {
    { "nvim-neotest/nvim-nio", version = "1.10.0" },
    { "nvim-lua/plenary.nvim", version = "0.1.4" },
    "antoinemadec/FixCursorHold.nvim",
    { "nvim-treesitter/nvim-treesitter", version = "0.9.3" },
    "nvim-neotest/neotest-jest",
  },
  keys = {
    {
      "<leader>dt",
      function()
        local neotest = require("neotest")
        neotest.run.run()
      end,
      mode = "",
      desc = "[D]ocument Nearest [t]est",
    },
    {
      "<leader>dT",
      function()
        local neotest = require("neotest")
        neotest.run.run(vim.fn.expand("%"))
      end,
      mode = "",
      desc = "[D]ocument All [T]ests",
    },
    {
      "<leader>wt",
      function()
        local neotest = require("neotest")
        neotest.run.run(vim.uv.cwd())
      end,
      mode = "",
      desc = "[W]orkspace [t]ests",
    },
  },
  opts = function()
    local neotestJest = require("neotest-jest")

    return {
      floating = { enabled = false },
      status = { virtual_text = false, signs = true },
      diagnostic = { enabled = true, severity = 1 },
      log_level = 1,
      adapters = {
        neotestJest({
          jestCommand = "yarn test",
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
      },
    }
  end,
}
