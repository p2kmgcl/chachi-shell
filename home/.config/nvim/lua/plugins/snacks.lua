local function get_snacks(opts)
  local options = { close_mini_files = true }
  if opts then
    options = vim.tbl_deep_extend("force", options, opts)
  end

  local snacks = require("snacks")
  if options.close_mini_files then
    local mini_files = require("mini.files")
    mini_files.close()
  end
  return snacks
end

local function copy_git_link()
  get_snacks().gitbrowse({
    notify = true,
    open = function(url)
      vim.fn.setreg("+", url)
    end,
  })
end

local function git_status()
  local items = {}
  local handle = io.popen("git status --porcelain")
  if handle then
    local result = handle:read("*a")
    handle:close()

    for line in result:gmatch("[^\r\n]+") do
      local status = line:sub(1, 2)
      local file_or_dir = line:sub(4)

      if file_or_dir:sub(-1) == "/" then
        for file in vim.fs.dir(file_or_dir) do
          local file_name = file_or_dir .. file
          table.insert(items, { status = status, file = file_name, text = file_name })
        end
      else
        table.insert(items, { status = status, file = file_or_dir, text = file_or_dir })
      end
    end
  end

  get_snacks().picker.pick({
    items = items,
    preview = "git_diff",
    format = function(item)
      local package_or_dir = vim.fs.dirname(item.file)
      local basename = vim.fs.basename(item.file)

      return {
        { item.status, "SnacksPickerIconField" },
        { " ", "SnacksPickerDelim" },
        { basename, "SnacksPickerFile" },
        { " ", "SnacksPickerDelim" },
        { package_or_dir, "SnacksPickerPathHidden" },
      }
    end,
  })
end

local function grep()
  local get_mini_files_path = require("helpers.get-mini-files-path")
  local mini_files_path = get_mini_files_path({ close_explorer = true })

  local title = "Grep"
  if mini_files_path then
    title = title .. " (" .. vim.fn.fnamemodify(mini_files_path, ":.") .. ")"
  end

  get_snacks({ close_explorer = false }).picker.grep({
    title = title,
    cwd = mini_files_path,
  })
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    image = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
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
        explorer = {
          hidden = true,
          follow = true,
          layout = {
            preset = "sidebar",
            preview = false,
            layout = {
              position = "right",
              width = 80,
            },
          },
        },
        grep = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },
    quickfile = { enabled = false },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- stylua: ignore start
    { "[[", function() get_snacks().words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "]]", function() get_snacks().words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "<leader>,", function() get_snacks().picker.buffers() end, desc = "Buffers" },
    { "<leader>bd", function() get_snacks().bufdelete(); end, desc = "Delete Buffer" },
    { "<leader>cd", function() get_snacks().picker.diagnostics_buffer() end, desc = "Code Diagnostics (current file)" },
    { "<leader>cD", function() get_snacks().picker.diagnostics() end, desc = "Code Diagnostics (root)" },
    { "<leader>gy", copy_git_link, desc = "Git Link (copy)", mode = { "n", "v" } },
    { "<leader>gY", function() get_snacks().gitbrowse() end, desc = "Git Link (open)", mode = { "n", "v" } },
    { "<leader>gg", function() get_snacks().lazygit({ configure = false }) end, desc = "Lazygit" },
    { "<leader>gl", function() get_snacks().picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gs", git_status, desc = "Git Status" },
    { "<leader>sg", grep, desc = "Grep" },
    { "<leader>sh", function() get_snacks().picker.help() end, desc = "Help Pages" },
    { "<leader>sR", function() get_snacks().picker.resume() end, desc = "Resume" },
    { "<leader>su", function() get_snacks().picker.undo() end, desc = "Undo History" },
    { "<leader>un", function() get_snacks().notifier.hide() end, desc = "Dismiss All Notifications" },
    { "gd", function() get_snacks().picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() get_snacks().picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gI", function() get_snacks().picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grr", function() get_snacks().picker.lsp_references() end, nowait = true, desc = "References" },
    { "gy", function() get_snacks().picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    -- stylua: ignore end
  },
}
