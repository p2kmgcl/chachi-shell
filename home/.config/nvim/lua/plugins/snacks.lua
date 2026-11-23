local function get_snacks()
  return require("snacks")
end

local function copy_git_link()
  get_snacks().gitbrowse({
    notify = false,
    open = function(url)
      vim.fn.setreg("+", url)
      vim.notify(url, vim.log.levels.INFO, { title = "Yanked current file git link" })
    end,
  })
end

local function grep()
  local explorer_path = require("helpers.get-explorer-path")()

  local title = "Grep"
  if explorer_path then
    title = title .. " (" .. vim.fn.fnamemodify(explorer_path, ":.") .. ")"
  end

  get_snacks().picker.grep({
    title = title,
    cwd = explorer_path,
  })
end

local function find()
  local explorer_path = require("helpers.get-explorer-path")()

  local title = "Find"
  if explorer_path then
    title = title .. " (" .. vim.fn.fnamemodify(explorer_path, ":.") .. ")"
  end

  get_snacks().picker.files({
    title = title,
    cwd = explorer_path,
    hidden = true,
    ignored = false,
    follow = true,
  })
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    image = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = true },
    styles = {
      notification = { wo = { winblend = 0 } },
    },
    picker = {
      enabled = true,
      icons = {
        tree = {
          vertical = "  ",
          middle = "  ",
          last = "  ",
        },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 999,
          icon_width = 2,
          git_status_hl = false,
        },
      },
      previewers = {
        diff = {
          builtin = true,
        },
        git = {
          builtin = true,
        },
      },
      sources = {
        -- Keep manually opened commit pickers from checking out on Enter.
        git_log = { confirm = "focus_preview" },
        git_log_file = { confirm = "focus_preview" },
        git_log_line = { confirm = "focus_preview" },
        grep = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- stylua: ignore start
    { "[[", function() get_snacks().words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "]]", function() get_snacks().words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "<leader>,", function() get_snacks().picker.buffers() end, desc = "Buffers" },
    { "<leader><space>", find, desc = "Files" },
    { "<leader>bd", function() get_snacks().bufdelete(); end, desc = "Delete Buffer" },
    { "<leader>gy", copy_git_link, desc = "Yank git link", mode = { "n", "v" } },
    { "<leader>gY", function()
      local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "origin/HEAD" }, { text = true }):wait()
      local default_branch = result.stdout and result.stdout:match("origin/(.+)") or "main"
      default_branch = vim.trim(default_branch)
      get_snacks().gitbrowse({
        branch = default_branch,
        notify = false,
        open = function(url)
          vim.fn.setreg("+", url)
          vim.notify(url, vim.log.levels.INFO, { title = "Yanked current file git link (" .. default_branch .. ")" })
        end,
      })
    end, desc = "Yank git link (default branch)", mode = { "n", "v" } },
    { "<leader>lc", function() get_snacks().picker.lsp_config() end, desc = "Checkhealth" },
    { "<leader>sg", grep, desc = "Grep" },
    { "<leader>sh", function() get_snacks().picker.help() end, desc = "Help Pages" },
    { "<leader>sR", function() get_snacks().picker.resume() end, desc = "Resume" },
    { "<leader>su", function() get_snacks().picker.undo() end, desc = "Undo History" },
    { "gd", function() get_snacks().picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() get_snacks().picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gI", function() get_snacks().picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grr", function() get_snacks().picker.lsp_references() end, nowait = true, desc = "References" },
    { "gy", function() get_snacks().picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    -- stylua: ignore end
  },
}
