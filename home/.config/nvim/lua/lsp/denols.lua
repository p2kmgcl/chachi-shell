local lspconfig = require("lspconfig")

return {
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.lock"),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          deno = "https://deno.land",
          std = "https://deno.land/std",
        },
      },
    },
  },
}
