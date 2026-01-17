local utils = require("sidebar.utils")
local M = {}

M.skip_refresh = false

local function render(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local in_sidebar = vim.api.nvim_get_current_buf() == buf
  local items = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(b)
    local ft = vim.bo[b].filetype
    if vim.bo[b].buflisted and name ~= "" and not ft:match("^sidebar_") and ft ~= "neo-tree" then
      local path = utils.get_relative_path(name)
      local basename = vim.fn.fnamemodify(name, ":t")
      local icon, hl = utils.get_icon(basename, "file")
      items[#items + 1] = { bufnr = b, path = path, name = basename, icon = icon, icon_hl = hl }
    end
  end
  table.sort(items, function(a, b) return a.path < b.path end)

  local lines, entries, highlights = utils.render_tree(items, function(item, pad)
    return pad .. item.icon .. " " .. item.name,
      {{ col_start = #pad, col_end = #pad + #item.icon, hl = item.icon_hl }}
  end)

  utils.set_lines(buf, lines, highlights)
  vim.b[buf].entries = entries

  if in_sidebar then
    local max_line = vim.api.nvim_buf_line_count(buf)
    cursor[1] = math.min(cursor[1], max_line)
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end
end

local function setup_keymaps(buf)
  vim.keymap.set("n", "<CR>", function()
    local entry = vim.b[buf].entries[vim.fn.line(".")]
    if entry and entry.bufnr then
      require("edgy").goto_main()
      vim.api.nvim_set_current_buf(entry.bufnr)
    end
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "dd", function()
    local entry = vim.b[buf].entries[vim.fn.line(".")]
    if entry and entry.bufnr then
      M.skip_refresh = true
      local target = entry.bufnr
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == target then
          local alt = vim.fn.bufnr("#")
          if alt > 0 and alt ~= target and vim.api.nvim_buf_is_valid(alt) and vim.bo[alt].buflisted then
            vim.api.nvim_win_set_buf(win, alt)
          else
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
              if b ~= target and vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b) then
                vim.api.nvim_win_set_buf(win, b)
                break
              end
            end
          end
        end
      end
      pcall(vim.api.nvim_buf_delete, target, {})
      render(buf)
      vim.defer_fn(function() M.skip_refresh = false end, 100)
    end
  end, { buffer = buf, nowait = true })
end

function M.open()
  local buf = utils.get_or_create_buffer("buffers")
  if not vim.b[buf].keymaps_set then
    setup_keymaps(buf)
    vim.b[buf].keymaps_set = true
  end
  render(buf)
  utils.show_buffer(buf)
end

function M.refresh()
  if M.skip_refresh then return end
  local buf = utils.buffers.buffers
  if buf and vim.api.nvim_buf_is_valid(buf) and #vim.fn.win_findbuf(buf) > 0 then
    render(buf)
  end
end

return M
