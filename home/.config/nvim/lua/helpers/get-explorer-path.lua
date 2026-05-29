return function()
  local ok, view = pcall(require, "a-side.view")
  if not ok then return nil end
  return view.cursor_path()
end
