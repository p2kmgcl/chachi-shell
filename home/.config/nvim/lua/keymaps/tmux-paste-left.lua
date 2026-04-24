local function find_claude_pane()
  local result =
    vim.system({ "tmux", "list-panes", "-f", "#{m/ri:claude,#{pane_title}}", "-F", "#{pane_id}" }):wait()

  if result.code ~= 0 then
    return nil, result.stderr or "tmux list-panes failed"
  end

  local pane_id = (result.stdout or ""):match("(%%%d+)")
  if pane_id then
    return pane_id
  end

  return nil, "No tmux pane running claude found"
end

local function send(text)
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

local function buf_path()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if path == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN, { title = "Tmux paste claude" })
    return nil
  end
  return path
end

local function send_file()
  local path = buf_path()
  if path then
    send("@" .. path)
  end
end

local function send_range()
  local path = buf_path()
  if not path then
    return
  end
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  local range = s == e and tostring(s) or (s .. "-" .. e)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  send("@" .. path .. ":" .. range)
end

vim.keymap.set("n", "<leader>cc", send_file, { desc = "[C]ode to [C]laude" })
vim.keymap.set("x", "<leader>cc", send_range, { desc = "[C]ode to [C]laude" })
