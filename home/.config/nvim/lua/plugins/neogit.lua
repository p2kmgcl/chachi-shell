return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = true,
  keys = {
    {
      "<leader>gc",
      function()
        vim.cmd("Neogit commit")
      end,
      mode = "",
      desc = "[G]it [c]ommit",
    },
    {
      "<leader>gs",
      function()
        vim.cmd("Neogit")
      end,
      mode = "",
      desc = "[G]it [s]tatus",
    },
  },
  config = {
    git_services = {
      ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
      ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["azure.com"] = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
      ["gitlab.protontech.ch"] = "https://gitlab.protontech.ch/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
    },
    console_timeout = 300,
    auto_show_console = true,
    auto_close_console = false,
  },
}
