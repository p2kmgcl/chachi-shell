return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        path_display = { "smart" },
      },
      pickers = {
        grep_string = {
          additional_args = function()
            return { "--ignore", "--hidden" }
          end,
        },
        live_grep = {
          additional_args = function()
            return { "--ignore", "--hidden" }
          end,
        },
      },
    },
  },
}
