return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "deno",
        "docker",
        "dom",
        "esbuild",
        "git",
        "html",
        "javascript",
        "jest",
        "react",
        "rust",
        "sass",
      },
    },
  },
}
