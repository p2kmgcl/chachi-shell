return {
  "gennaro-tedesco/nvim-possession",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  keys = {
    {
      "<leader>sl",
      function()
        require("nvim-possession").list()
      end,
      desc = "[S]ession [l]ist",
    },
    {
      "<leader>sn",
      function()
        require("nvim-possession").new()
      end,
      desc = "[S]ession [n]ew",
    },
    {
      "<leader>su",
      function()
        require("nvim-possession").update()
      end,
      desc = "[S]ession [u]pdate",
    },
    {
      "<leader>sd",
      function()
        require("nvim-possession").delete()
      end,
      desc = "[S]ession [d]elete",
    },
  },
  config = function()
    require("nvim-possession").setup({
      autoload = true,
      autosave = true,
      autoprompt = true,
    })
  end,
}
