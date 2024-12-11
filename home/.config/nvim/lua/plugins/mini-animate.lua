return {
  "echasnovski/mini.animate",
  event = "BufReadPost",
  config = function()
    local animate = require("mini.animate")

    animate.setup({
      scroll = {
        timing = animate.gen_timing.linear({
          easing = "in-out",
          duration = 10,
          unit = "step",
        }),
      },
      cursor = { enable = false },
      open = { enable = false },
      close = { enable = false },
    })
  end,
}
