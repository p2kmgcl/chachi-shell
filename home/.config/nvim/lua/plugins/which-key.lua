-- Useful plugin to show you pending keybinds.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").register({
      ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    })
    -- visual mode
    require("which-key").register({
      ["<leader>h"] = { "Git [H]unk" },
    }, { mode = "v" })
  end,
}
