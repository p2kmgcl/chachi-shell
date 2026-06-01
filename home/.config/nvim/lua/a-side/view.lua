local M = {}

vim.api.nvim_set_hl(0, "AsideSeparator", { link = "WinSeparator", default = true })

local MIN_WIDTH = 30
local MAX_WIDTH_FRACTION = 0.4
local WIN_BAR_HEIGHT = 1

local regions = {
  require("a-side.regions.buffers.buffers"),
  require("a-side.regions.explorer.explorer"),
  require("a-side.regions.git.git"),
}
local scroll_indicators = require("a-side.ui.scroll_indicators")
local prevent_scroll_past_end = require("a-side.ui.prevent_scroll_past_end")

local bufnrs = {}
local winids = {}
local closing = false
local close_autocmd_id
local resize_autocmd_id
local dir_autocmd_id

local function ensure_buffer(region)
  local bufnr = bufnrs[region.name]
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr
  end
  bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].filetype = region.filetype
  region.render(bufnr)
  bufnrs[region.name] = bufnr
  return bufnr
end

local function apply_window_locals(winid)
  vim.wo[winid].number = false
  vim.wo[winid].relativenumber = false
  vim.wo[winid].wrap = false
  vim.wo[winid].cursorline = true
  vim.wo[winid].winfixwidth = true
  vim.wo[winid].signcolumn = "no"
  vim.wo[winid].foldcolumn = "0"
  vim.wo[winid].statusline = " "
  vim.api.nvim_win_call(winid, function()
    vim.opt_local.fillchars = vim.tbl_extend("force", vim.opt.fillchars:get(), { horiz = " ", stl = " ", stlnc = " " })
  end)
  vim.wo[winid].winhighlight = "WinSeparator:AsideSeparator,StatusLine:AsideSeparator,StatusLineNC:AsideSeparator"
end

local function is_open()
  for _, region in ipairs(regions) do
    local winid = winids[region.name]
    if winid and vim.api.nvim_win_is_valid(winid) then
      return true
    end
  end
  return false
end

local FLOOR = 4 + WIN_BAR_HEIGHT
local SHARED_HEIGHT_FRACTION = 0.8

local function find_region(name)
  for _, region in ipairs(regions) do
    if region.name == name then
      return region
    end
  end
end

local function recompute_width()
  local any_winid
  local need = 0
  for _, region in ipairs(regions) do
    local bufnr = bufnrs[region.name]
    local winid = winids[region.name]
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) and winid and vim.api.nvim_win_is_valid(winid) then
      any_winid = any_winid or winid
      local winbar = vim.wo[winid].winbar
      if winbar and winbar ~= '' then
        local w = vim.fn.strdisplaywidth(winbar:gsub('%%%%', '%%'))
        if w > need then need = w end
      end
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        local w = vim.fn.strdisplaywidth(line)
        if w > need then
          need = w
        end
      end
    end
  end
  if not any_winid then
    return
  end

  local max_width = math.floor(vim.o.columns * MAX_WIDTH_FRACTION)
  if max_width < MIN_WIDTH then
    max_width = MIN_WIDTH
  end
  local width = math.max(MIN_WIDTH, math.min(need, max_width))

  vim.api.nvim_win_set_width(any_winid, width)
end

local function recompute_heights()
  local total = 0
  for _, region in ipairs(regions) do
    local winid = winids[region.name]
    if not (winid and vim.api.nvim_win_is_valid(winid)) then
      return
    end
    total = total + vim.api.nvim_win_get_height(winid)
  end

  local want_buffers = math.max(vim.api.nvim_buf_line_count(bufnrs["buffers"]) + WIN_BAR_HEIGHT, FLOOR)
  local want_git = math.max(vim.api.nvim_buf_line_count(bufnrs["git"]) + WIN_BAR_HEIGHT, FLOOR)

  local budget = math.min(math.floor(total * SHARED_HEIGHT_FRACTION), total - FLOOR)
  if budget < 0 then
    budget = 0
  end

  local buffers_height, git_height
  if want_buffers + want_git <= budget then
    buffers_height, git_height = want_buffers, want_git
  else
    buffers_height = math.max(math.floor(budget * want_buffers / (want_buffers + want_git)), FLOOR)
    git_height = math.max(budget - buffers_height, FLOOR)
  end

  vim.api.nvim_win_set_height(winids["buffers"], buffers_height)
  vim.api.nvim_win_set_height(winids["git"], git_height)

  local explorer_height = math.max(total - buffers_height - git_height, FLOOR)
  vim.api.nvim_win_set_height(winids["explorer"], explorer_height)

  for _, region in ipairs(regions) do
    local winid = winids[region.name]
    if winid and vim.api.nvim_win_is_valid(winid) then
      scroll_indicators.refresh(winid)
    end
  end
end

local close -- forward declaration

local function register_autocmds()
  if close_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, close_autocmd_id)
  end
  close_autocmd_id = vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      if closing then
        return
      end
      local closed = tonumber(args.match)
      for _, region in ipairs(regions) do
        if winids[region.name] == closed then
          close()
          return
        end
      end
    end,
  })

  if resize_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, resize_autocmd_id)
  end
  resize_autocmd_id = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if closing then
        return
      end
      recompute_width()
    end,
  })

  if dir_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, dir_autocmd_id)
  end
  dir_autocmd_id = vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      if closing then
        return
      end
      for _, region in ipairs(regions) do
        if region.disable then
          region.disable()
        end
        if region.enable then
          local b = bufnrs[region.name]
          if b and vim.api.nvim_buf_is_valid(b) then
            region.enable(b)
          end
        end
      end
    end,
  })
end

local function open()
  local prev_win = vim.api.nvim_get_current_win()

  vim.cmd("vsplit")
  vim.cmd("wincmd L")
  local first = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(first, MIN_WIDTH)
  winids[regions[1].name] = first
  vim.api.nvim_win_set_buf(first, ensure_buffer(regions[1]))
  apply_window_locals(first)

  for i = 2, #regions do
    vim.api.nvim_set_current_win(winids[regions[i - 1].name])
    vim.cmd("belowright split")
    local winid = vim.api.nvim_get_current_win()
    winids[regions[i].name] = winid
    vim.api.nvim_win_set_buf(winid, ensure_buffer(regions[i]))
    apply_window_locals(winid)
  end

  recompute_width()
  recompute_heights()

  register_autocmds()

  for _, region in ipairs(regions) do
    if region.enable then
      region.enable(bufnrs[region.name])
    end
  end

  local winid_list = {}
  for _, region in ipairs(regions) do
    table.insert(winid_list, winids[region.name])
  end
  scroll_indicators.enable(winid_list)
  prevent_scroll_past_end.enable(winid_list)

  vim.api.nvim_set_current_win(prev_win)
end

close = function()
  if closing then
    return
  end
  closing = true
  scroll_indicators.disable()
  prevent_scroll_past_end.disable()
  for _, region in ipairs(regions) do
    if region.disable then
      region.disable()
    end
  end
  for _, region in ipairs(regions) do
    local winid = winids[region.name]
    if winid and vim.api.nvim_win_is_valid(winid) then
      pcall(vim.api.nvim_win_close, winid, true)
    end
    winids[region.name] = nil
  end
  if close_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, close_autocmd_id)
    close_autocmd_id = nil
  end
  if resize_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, resize_autocmd_id)
    resize_autocmd_id = nil
  end
  if dir_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, dir_autocmd_id)
    dir_autocmd_id = nil
  end
  closing = false
end

function M.toggle()
  if is_open() then
    close()
  else
    open()
  end
end

function M.resize(name)
  if not is_open() then
    return
  end
  if not find_region(name) then
    return
  end
  recompute_width()
  recompute_heights()
end

function M.ensure_editor_win()
  local aside = {}
  for _, region in ipairs(regions) do
    aside[winids[region.name]] = true
  end
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not aside[w] then
      return w
    end
  end
  local top = winids[regions[1].name]
  if top and vim.api.nvim_win_is_valid(top) then
    vim.api.nvim_set_current_win(top)
  end
  vim.cmd("topleft vnew")
  return vim.api.nvim_get_current_win()
end

function M.focus(name)
  if not is_open() then
    open()
  end
  local winid = winids[name]
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_set_current_win(winid)
  end
end

function M.cursor_path()
  local win = vim.api.nvim_get_current_win()
  for _, region in ipairs(regions) do
    if winids[region.name] == win then
      if region.cursor_path then return region.cursor_path() end
      return nil
    end
  end
  return nil
end

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = open,
})

return M
