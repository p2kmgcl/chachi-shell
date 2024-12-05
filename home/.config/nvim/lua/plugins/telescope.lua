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
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  cmd = "Telescope",
  keys = {
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "Find in current buffer",
    },
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
      function()
        require("telescope.builtin").find_files({
          hidden = true,
        })
      end,
      desc = "[F]ind [F]iles",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep({
          additional_args = function()
            return { "--ignore-vcs", "--ignore-global", "--hidden", "--iglob", "!.git/*" }
          end,
        })
      end,
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
      function()
        require("telescope.builtin").oldfiles({
          cwd_only = true,
        })
      end,
      desc = "[F]ind [O]ld Files",
    },
    {
      "<leader>fR",
      "<cmd>Telescope resume<cr>",
      desc = "[F]ind [R]esume",
    },
  },
  config = function()
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

    require("telescope").setup({
      defaults = {
        path_display = filename_first,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          preview_cutoff = 180,
          horizontal = {
            prompt_position = "top",
            preview_width = 0.6,
            results_width = 0.4,
          },
        },
        extensions_list = { "fzf" },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
      pickers = {
        live_grep = {
          additional_args = function()
            return { "--ignore-vcs", "--ignore-global", "--hidden", "--iglob", "!.git/*" }
          end,
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
  end,
}
