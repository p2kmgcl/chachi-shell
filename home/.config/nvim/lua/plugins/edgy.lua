return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-neo-tree/neo-tree.nvim" },
  keys = {
    { "<leader>e", function() require("edgy").toggle("right") end, desc = "Toggle Sidebar" },
  },
  opts = {
    right = {
      { title = "Buffers", ft = "sidebar_buffers", size = { height = 0.25 }, pinned = true, open = "SidebarBuffers" },
      { title = "Explorer", ft = "neo-tree", filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end, pinned = true, open = "Neotree position=right filesystem reveal" },
      { title = "Git", ft = "sidebar_git", size = { height = 0.25 }, pinned = true, open = "SidebarGit" },
    },
    options = { right = { size = 50 } },
    wo = { number = false, relativenumber = false, signcolumn = "no" },
    close_when_all_hidden = false,
    keys = { q = false, ["<c-q>"] = false },
  },
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "screen"
    require("sidebar").setup()
  end,
}
