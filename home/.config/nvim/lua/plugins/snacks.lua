return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    { "<leader>fe", false },
    { "<leader>fE", false },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
    -- Override search keymaps: lowercase = current file dir, uppercase = project root
    {
      "<leader>sg",
      function()
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("No file is currently open", vim.log.levels.WARN)
          return
        end
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        require("snacks").picker.grep({ cwd = current_dir })
      end,
      desc = "Grep (current file dir)",
    },
    {
      "<leader>sG",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Grep (project root)",
    },
    {
      "<leader>sw",
      function()
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("No file is currently open", vim.log.levels.WARN)
          return
        end
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        require("snacks").picker.grep({ cwd = current_dir, search = vim.fn.expand("<cword>") })
      end,
      desc = "Word (current file dir)",
    },
    {
      "<leader>sW",
      function()
        require("snacks").picker.grep({ search = vim.fn.expand("<cword>") })
      end,
      desc = "Word (project root)",
    },
    {
      "<leader>ff",
      function()
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          vim.notify("No file is currently open", vim.log.levels.WARN)
          return
        end
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        require("snacks").picker.files({ cwd = current_dir })
      end,
      desc = "Find Files (current file dir)",
    },
    {
      "<leader>fF",
      function()
        require("snacks").picker.files()
      end,
      desc = "Find Files (project root)",
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
        grep = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },
  },
}
