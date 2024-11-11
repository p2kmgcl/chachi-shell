return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "3.27",
  dependencies = {
    { "nvim-lua/plenary.nvim", version = "0.1.4" },
    { "nvim-tree/nvim-web-devicons", version = "0.100", enabled = vim.g.have_nerd_font },
    { "MunifTanjim/nui.nvim", version = "0.3.0" },
  },
  lazy = true,
  keys = {
    {
      "<leader>e",
      function()
        vim.cmd("Neotree action=focus source=filesystem reveal=true")
      end,
      mode = "",
      desc = "[E]xplorer",
    },
    {
      "<leader>b",
      function()
        vim.cmd("Neotree action=focus source=buffers reveal=true")
      end,
      mode = "",
      desc = "[B]uffers",
    },
  },
  opts = {
    close_if_last_window = true,
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
      group_empty_dirs = true,
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
      mappings = {
        ["<space>"] = "noop",
      },
    },
  },
}
