local M = {}

function M.get(item)
  local ok, mini = pcall(require, 'mini.icons')
  if not ok then return ' ', nil end
  local kind = item.is_dir and 'directory' or 'file'
  local icon, hl = mini.get(kind, item.name)
  return icon or ' ', hl
end

return M
