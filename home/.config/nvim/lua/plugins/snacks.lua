return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
  },
  opts = {
    indent = {
      enabled = false,
    },
    picker = {
      formatters = {
        file = {
          filename_first = true,
          truncate = 999,
          icon_width = 2,
          git_status_hl = false,
        },
      },
      previewers = {
        diff = {
          builtin = false,
          cmd = { "delta", "--detect-dark-light", "always", "--no-gitconfig", "--paging=never" },
        },
        git = {
          builtin = false,
        },
      },
      sources = {
        explorer = {
          hidden = true,
          follow = true,
          layout = {
            preset = "sidebar",
            preview = false,
            layout = {
              position = "right",
              width = 80,
            },
          },
        },
      },
    },
  },
}
