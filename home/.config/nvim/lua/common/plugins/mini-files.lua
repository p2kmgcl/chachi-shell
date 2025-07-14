return {
  "echasnovski/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 60,
      width_nofocus = 40,
      width_preview = 60,
    },
    options = {
      use_as_default_explorer = true,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (project root)",
    },
    { "<leader>fm", false },
    { "<leader>fM", false },
  },
}
