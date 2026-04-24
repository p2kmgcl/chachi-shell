local function find_claude_pane()
  local res = vim
    .system({ "tmux", "list-panes", "-F", "#{pane_id} #{pane_current_command} #{pane_title}" })
    :wait()
  if res.code ~= 0 then
    return nil, res.stderr or "tmux list-panes failed"
  end
  for line in vim.gsplit(res.stdout or "", "\n", { plain = true }) do
    if line:lower():match("claude") then
      local pane_id = line:match("^(%%%d+)")
      if pane_id then
        return pane_id
      end
    end
  end
  return nil, "No tmux pane running claude found"
end

local function send_to_claude(with_range)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if path == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN, { title = "Tmux paste claude" })
    return
  end

  local text = "@" .. path
  if with_range then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    local range = start_line == end_line and tostring(start_line) or (start_line .. "-" .. end_line)
    text = text .. ":" .. range
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end

  local pane, err = find_claude_pane()
  if not pane then
    vim.notify(err, vim.log.levels.ERROR, { title = "Tmux paste claude" })
    return
  end

  local load = vim.system({ "tmux", "load-buffer", "-" }, { stdin = text }):wait()
  if load.code ~= 0 then
    vim.notify(load.stderr or "tmux load-buffer failed", vim.log.levels.ERROR, { title = "Tmux paste claude" })
    return
  end

  local paste = vim.system({ "tmux", "paste-buffer", "-t", pane }):wait()
  if paste.code ~= 0 then
    vim.notify(paste.stderr or "tmux paste-buffer failed", vim.log.levels.ERROR, { title = "Tmux paste claude" })
    return
  end

  local select = vim.system({ "tmux", "select-pane", "-t", pane }):wait()
  if select.code ~= 0 then
    vim.notify(select.stderr or "tmux select-pane failed", vim.log.levels.ERROR, { title = "Tmux paste claude" })
    return
  end

  vim.notify(text .. " → " .. pane, vim.log.levels.INFO, { title = "Tmux paste claude" })
end

vim.keymap.set("n", "<leader>yl", function()
  send_to_claude(false)
end, { desc = "Paste file path to claude tmux pane" })

vim.keymap.set("x", "<leader>yl", function()
  send_to_claude(true)
end, { desc = "Paste file path + line range to claude tmux pane" })
