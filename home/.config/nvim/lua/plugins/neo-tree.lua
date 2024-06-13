return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  keys = {
    {
      "<leader>e",
      function()
        vim.cmd("Neotree reveal")
      end,
      mode = "",
      desc = "[E]xplorer",
    },
  },
  opts = {
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = false,
      },
    },
    default_component_configs = {
      file_size = { enabled = false },
      type = { enabled = false },
      last_modified = { enabled = false },
      created = { enabled = false },
    },
    window = {
      auto_expand_width = "fit_content",
      position = "right",
    },
  },
}
