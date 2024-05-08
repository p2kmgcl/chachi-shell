return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>gs",
      "<cmd>Neogit<cr>",
      desc = "[G]it [s]tatus",
    },
  },
  config = {
    git_services = {
      ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
      ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["gitlab.protontech.ch"] = "https://gitlab.protontech.ch/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
    },
  },
}
