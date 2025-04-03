return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  keys = {
    {
      "<leader>fb",
      "<cmd>Telescope buffers<cr>",
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader>fd",
      "<cmd>Telescope diagnostics<cr>",
      desc = "[F]ind [D]iagnostics",
    },
    {
      "<leader>ff",
      "<cmd>Telescope find_files<cr>",
      desc = "[F]ind [F]iles",
    },
    {
      "<leader>fg",
      "<cmd>Telescope live_grep<cr>",
      desc = "[F]ind by [G]rep",
    },
    {
      "<leader>fh",
      "<cmd>Telescope help_tags<cr>",
      desc = "[F]ind [H]elp",
    },
    {
      "<leader>fk",
      "<cmd>Telescope keymaps<cr>",
      desc = "[F]ind [K]eymaps",
    },
    {
      "<leader>fm",
      "<cmd>Telescope git_status<cr>",
      desc = "[F]ind [M]odified Files",
    },
    {
      "<leader>fo",
      "<cmd>Telescope oldfiles<cr>",
      desc = "[F]ind [O]ld Files",
    },
    {
      "<leader>fR",
      "<cmd>Telescope resume<cr>",
      desc = "[F]ind [R]esume",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local function filename_first(_, path)
      local tail = require("telescope.utils").path_tail(path)
      local root = vim.fs.dirname(path)
      if root == "." then
        return tail
      end
      return string.format("%s\t\t%s", tail, root)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", {
            link = "Comment",
          })
        end)
      end,
    })

    telescope.setup({
      defaults = {
        selection_caret = "➤ ",
        path_display = filename_first,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          preview_cutoff = 180,
          horizontal = {
            prompt_position = "top",
            preview_width = 0.6,
            results_width = 0.4,
          },
        },
        results_title = false,
        cache_picker = false,
        file_ignore_patterns = { "node_modules", "%.git/", "dist", "build", "vendor" },

        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },

        file_sorter = require("telescope.sorters").get_fzf_sorter,
        generic_sorter = require("telescope.sorters").get_fzf_sorter,
      },

      pickers = {
        find_files = {
          find_command = {
            "fd",
            "--type",
            "f",
            "--hidden",
            "--follow",
            "--exclude",
            ".git",
            "--exclude",
            "node_modules",
            "--exclude",
            "build",
            "--exclude",
            "dist",
            "--exclude",
            "vendor",
          },
        },
        oldfiles = {
          cwd_only = true,
        },
      },
    })
  end,
}
