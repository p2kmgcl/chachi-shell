vim.keymap.set("n", "<leader>gS", function()
  vim.notify("Loading changed files…", vim.log.levels.INFO)

  vim.system({ "git", "do-list-changed-files-vs-main" }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(result.stderr or "git do-list-changed-files-vs-main failed", vim.log.levels.ERROR)
        return
      end

      local items = {}
      for line in (result.stdout or ""):gmatch("[^\r\n]+") do
        local file = vim.trim(line)
        if file ~= "" and vim.uv.fs_stat(file) then
          table.insert(items, { file = file, text = file })
        end
      end

      if #items == 0 then
        vim.notify("No changed files vs main", vim.log.levels.INFO)
        return
      end

      require("snacks").picker.pick({
        title = "Changed files vs main",
        items = items,
        preview = "file",
        format = function(item)
          local package_or_dir = vim.fs.dirname(item.file)
          local basename = vim.fs.basename(item.file)

          return {
            { basename, "SnacksPickerFile" },
            { " ", "SnacksPickerDelim" },
            { package_or_dir, "SnacksPickerPathHidden" },
          }
        end,
      })
    end)
  end)
end, { desc = "Git changed files vs main (snacks picker)" })
