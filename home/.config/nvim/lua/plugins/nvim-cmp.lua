return {
  "hrsh7th/nvim-cmp",
  opts = {
    mapping = {
      ["<CR>"] = function(fallback)
        fallback()
      end,
    },
    experimental = {
      ghost_text = false,
    },
  },
}
