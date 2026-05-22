return function()
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if not ok then
    return nil
  end

  local state = manager.get_state("filesystem")
  if not state or not state.tree then
    return nil
  end

  local win = state.winid
  if not win or not vim.api.nvim_win_is_valid(win) then
    return nil
  end
  if vim.api.nvim_get_current_win() ~= win then
    return nil
  end

  local node = state.tree:get_node()
  if node then
    local path = node:get_id()
    if node.type == "directory" then
      return path
    end
    return vim.fs.dirname(path)
  end

  return state.path
end
