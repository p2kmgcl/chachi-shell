local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
  },
}

M.nvimtree = {
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  sort_by = "case_sensitive",
  update_focused_file = {
    enable = true,
  },
  view = {
    width = { min = 30, max = 60 },
    side = "right",
    centralize_selection = true,
  },
}

return M
