return function(opts)
  local mini_files = require("mini.files")
  local mini_files_path = nil

  if mini_files.get_explorer_state() then
    local mini_files_entry = mini_files.get_fs_entry()
    if mini_files_entry then
      mini_files_path = vim.fs.dirname(mini_files_entry.path)
    end
  end

  if opts and opts.close_explorer then
    mini_files.close()
  end

  return mini_files_path
end
