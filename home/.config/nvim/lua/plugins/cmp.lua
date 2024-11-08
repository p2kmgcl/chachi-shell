-- Autocompletion
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require("cmp")
    local snippy = require("snippy")
    snippy.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          snippy.expand_snippet(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      window = {
        completion = {},
        documentation = {},
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),

        ["<C-Space>"] = cmp.mapping.complete({}),

        ["<C-l>"] = cmp.mapping(function()
          if snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if snippy.can_jump(-1) then
            snippy.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "snippy" },
        { name = "path" },
      },
    })
  end,
}
