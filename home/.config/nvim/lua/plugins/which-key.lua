-- Useful plugin to show you pending keybinds.
return {
  "folke/which-key.nvim",
  version = "3.13.3",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      icons = {
        mappings = false,
      },
    })

    -- Document existing key chains
    require("which-key").add({
      { "<leader>c", group = "[C]ode" },
      { "<leader>c_", hidden = true },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>d_", hidden = true },
      { "<leader>f", group = "[F]ind" },
      { "<leader>f_", hidden = true },
      { "<leader>g", group = "[G]it" },
      { "<leader>g_", hidden = true },
      { "<leader>n", group = "[N]ew" },
      { "<leader>n_", hidden = true },
      { "<leader>r", group = "[R]un" },
      { "<leader>r_", hidden = true },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>t_", hidden = true },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>w_", hidden = true },
    })
  end,
}
