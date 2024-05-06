return {
  "echasnovski/mini.files",
  keys = {
    {
      "<leader>e",
      function()
        vim.cmd("e .")
      end,
      mode = "",
      desc = "[E]xplorer (root)",
    },
    {
      "<leader>E",
      function()
        vim.cmd("e %:p:h")
      end,
      mode = "",
      desc = "[E]xplorer (current file)",
    },
  },
  opts = {
    windows = {
      preview = true,
      width_focus = 40,
      width_preview = 80,
    },
    options = {
      permanent_delete = true,
      use_as_default_explorer = true,
    },
  },
}
