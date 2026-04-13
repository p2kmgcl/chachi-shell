return {
  -- Parser management only — lazy-loaded to avoid plugin query predicates
  -- conflicting with Neovim 0.13+ built-in treesitter highlighter.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      local ensure_installed = {
        "bash",
        "css",
        "csv",
        "dockerfile",
        "editorconfig",
        "fish",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "regex",
        "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      }

      local installed = require("nvim-treesitter.config").get_installed()
      local missing = vim.iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()

      if #missing > 0 then
        ts.install(missing)
      end
    end,
  },

  -- Built-in treesitter highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      min_window_height = 20,
    },
  },
}
