return function()
  local miniFiles = require("mini.files")
  local miniFilesPath = nil

  if miniFiles.get_explorer_state() then
    local miniFilesEntry = miniFiles.get_fs_entry()
    if miniFilesEntry then
      miniFilesPath = vim.fs.dirname(miniFilesEntry.path)
    end
  end

  return miniFilesPath
end
