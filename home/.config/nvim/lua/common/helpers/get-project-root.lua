return function(file_path)
  if file_path == "" then
    return nil
  end

  local get_dir_config = require("common.helpers.get-dir-config")
  local current_dir = vim.fn.fnamemodify(file_path, ":h")
  local upmost_config = nil

  while current_dir ~= "/" and current_dir ~= "" do
    local config = get_dir_config(current_dir)
    if config then
      upmost_config = config
    end

    local parent = vim.fn.fnamemodify(current_dir, ":h")
    if parent == current_dir then
      break
    end
    current_dir = parent
  end

  if upmost_config then
    return vim.fs.dirname(upmost_config.file)
  end

  return nil
end
