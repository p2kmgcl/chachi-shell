return {
  "nvim-mini/mini.ai",
  opts = function()
    local ai = require("mini.ai")

    return {
      custom_textobjects = {
        a = ai.gen_spec.treesitter({
          a = { "@parameter.outer", "@attribute.outer", "@assignment.outer" },
          i = { "@parameter.inner", "@attribute.inner", "@assignment.inner" },
        }),
      },
    }
  end,
}
