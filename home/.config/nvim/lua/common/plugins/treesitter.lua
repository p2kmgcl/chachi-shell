return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local flatten = require("common.helpers.flatten")
      local require_all = require("common.helpers.require-all")
      local ensure_installed = flatten(require_all("config/treesitter-languages.lua"))

      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
        },
        ensure_installed = ensure_installed,
      })
    end,
  },
}
