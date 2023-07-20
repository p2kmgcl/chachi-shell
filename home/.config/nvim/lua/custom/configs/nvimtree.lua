return {
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
