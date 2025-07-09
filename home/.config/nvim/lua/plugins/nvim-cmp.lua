return {
  "hrsh7th/nvim-cmp",
  enabled = true,
  opts = {
    performance = {
      debounce = 500,
      throttle = 500,
      fetching_timeout = 2000,
      max_view_entries = 100,
    },
    experimental = {
      ghost_text = false,
    },
    completion = {
      autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      completeopt = "fuzzy,menu,menuone,noinsert,popup",
      keyword_length = 3,
    },
    sources = {
      { name = "buffer", max_item_count = 100 },
      { name = "nvim_lsp", max_item_count = 100 },
    },
    mapping = {
      ["<CR>"] = function(fallback) fallback() end,
      ["<C-Space>"] = require("cmp").mapping.complete(),
      ["<C-n>"] = require("cmp").mapping.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
      ["<C-p>"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
    },
  },
}
