local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require("custom.configs.null-ls")
        end,
      },
    },
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = require("custom.configs.mason"),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require("custom.configs.treesitter"),
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = require("custom.configs.nvimtree"),
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
    {
      "kdheepak/lazygit.nvim",
      cmd = { "LazyGit" },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    opts = require("custom.configs.telescope"),
  }
}

return plugins
