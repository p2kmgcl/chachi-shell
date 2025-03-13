return {
  "NeogitOrg/neogit",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    "sindrets/diffview.nvim",
    { "nvim-telescope/telescope.nvim" },
  },
  lazy = true,
  keys = {
    {
      "<leader>gs",
      function()
        vim.cmd("Neogit")
      end,
      mode = "",
      desc = "[G]it [s]tatus",
    },
  },
  opts = {
    git_services = {
      ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
      ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["azure.com"] = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
      ["gitlab.protontech.ch"] = "https://gitlab.protontech.ch/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
    },
    status = {
      recent_commit_count = 100,
    },
    integrations = {
      telescope = true,
      diffview = true,
    },
    console_timeout = 300,
    disable_hint = true,
    auto_show_console = true,
    auto_close_console = false,
  },
}
