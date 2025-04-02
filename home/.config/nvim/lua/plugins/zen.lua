return {
  "folke/zen-mode.nvim",
  lazy = true,
  keys = {
    {
      "<leader>tz",
      function()
        require("zen-mode").toggle()
      end,
      mode = "",
      desc = "[T]oggle [z]en mode",
    },
  },
  opts = {
    window = {
      backdrop = 1,
      width = 100,
      height = 1,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
        wrap = true,
        linebreak = true,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      gitsigns = { enabled = true },
      tmux = { enabled = false },
      wezterm = { enabled = true },
    },
  },
}
