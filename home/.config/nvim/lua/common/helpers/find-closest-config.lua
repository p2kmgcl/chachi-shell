-- Find the closest config file to determine project type
return function(file_path)
  if file_path == "" then
    return nil
  end

  local get_dir_config = require("common.helpers.get-dir-config")
  local file_dir = vim.fn.fnamemodify(file_path, ":h")

  local closest_distance = math.huge
  local closest_config = nil

  -- Find the closest config file by traversing up the directory tree
  local current_dir = file_dir
  local distance = 0

  while current_dir ~= "/" and current_dir ~= "" do
    local config = get_dir_config(current_dir)
    if config and distance < closest_distance then
      closest_distance = distance
      closest_config = {
        type = config.type,
        file = config.file,
        distance = distance,
      }
    end

    -- Move up one directory
    local parent = vim.fn.fnamemodify(current_dir, ":h")
    if parent == current_dir then
      break
    end
    current_dir = parent
    distance = distance + 1
  end

  return closest_config
end
