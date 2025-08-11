return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = {
      enabled = false,
    },
    indent = {
      enabled = false,
    },
    picker = {
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
          builtin = false,
          cmd = { "delta", "--light", "--no-gitconfig", "--paging=never" },
        },
        git = {
          builtin = false,
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
  },
  keys = {
    -- stylua: ignore start
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>bd", function() Snacks.bufdelete(); end, desc = "Delete Buffer" },
    { "<leader>cd", function() Snacks.picker.diagnostics_buffer() end, desc = "Code Diagnostics (current file)" },
    { "<leader>cD", function() Snacks.picker.diagnostics() end, desc = "Code Diagnostics (root)" },
    { "<leader>gY", function() Snacks.gitbrowse() end, desc = "Git Link (open)", mode = { "n", "v" } },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep (root)" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    -- stylua: ignore end
    {
      "<leader>gs",
      function()
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

        Snacks.picker.pick({
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
      end,
      desc = "Git Status",
    },
    {
      "<leader>gy",
      function()
        Snacks.gitbrowse({
          notify = true,
          open = function(url)
            vim.fn.setreg("+", url)
          end,
        })
      end,
      desc = "Git Link (copy)",
      mode = { "n", "v" },
    },
  },
}
