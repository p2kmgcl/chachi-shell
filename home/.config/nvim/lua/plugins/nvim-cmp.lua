return {
  "nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.sorting.comparators = {
      cmp.config.compare.offset, -- Entries with smaller offset will be ranked higher.
      cmp.config.compare.exact, -- Entries with exact == true will be ranked higher.
      cmp.config.compare.score, -- Entries with higher score will be ranked higher.
      cmp.config.compare.recently_used, -- Entries that are used recently will be ranked higher.
      cmp.config.compare.kind, -- Entires with smaller ordinal value of 'kind' will be ranked higher.
      -- cmp.config.compare.length, -- Entires with shorter label length will be ranked higher.
      -- cmp.config.compare.locality, -- Entries with higher locality (i.e., words that are closer to the cursor) will be ranked higher.
      -- cmp.config.compare.order, -- Entries with smaller id will be ranked higher.
      -- cmp.config.compare.scopes, -- Entries defined in a closer scope will be ranked higher (e.g., prefer local variables to globals).
      -- cmp.config.compare.sort_text, -- Entries will be ranked according to the lexicographical order of sortText.
    }

    -- table.insert(opts.sources, 1, {
    --   name = "codeium",
    --   group_index = 1,
    --   priority = 1,
    -- })
  end,
}
