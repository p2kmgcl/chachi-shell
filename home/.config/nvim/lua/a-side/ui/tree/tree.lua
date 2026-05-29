local render = require('a-side.ui.tree.render')

local M = {}

local function path_parent(path)
  local parent = path:match('^(.*)/[^/]+$')
  if not parent or parent == '' then return nil end
  return parent
end

local function has_annotations(entry)
  return entry and entry.annotations and #entry.annotations > 0
end

function M.new(opts)
  assert(opts.bufnr, 'tree.new: bufnr required')
  assert(opts.root_path, 'tree.new: root_path required')
  assert(opts.root_label, 'tree.new: root_label required')
  assert(opts.get_children, 'tree.new: get_children required')

  local bufnr = opts.bufnr
  local root_path = opts.root_path
  local root_label = opts.root_label
  local get_children = opts.get_children
  local initially_expanded = opts.initially_expanded or false
  local on_expand = opts.on_expand
  local on_collapse = opts.on_collapse
  local on_select = opts.on_select
  local on_render = opts.on_render

  local ns = vim.api.nvim_create_namespace('aside-tree-' .. bufnr)
  local expanded = {}
  local seen_dirs = {}
  local entries = {}
  local path_to_row = {}
  local render_scheduled = false
  local destroyed = false
  local flatten = true
  local sticky_cursor_path = nil

  local function find_winid()
    local w = vim.fn.bufwinid(bufnr)
    if w == -1 then return nil end
    return w
  end

  local function apply_winbar(winid)
    if not winid then return end
    vim.wo[winid].winbar = root_label:gsub('%%', '%%%%')
  end

  local function row_for_path_or_ancestor(path)
    while path do
      local r = path_to_row[path]
      if r then return r end
      path = path_parent(path)
    end
    return nil
  end

  local function wrapped_get_children(path)
    local children = get_children(path)
    if children then
      for _, item in ipairs(children) do
        if item.is_dir and not seen_dirs[item.path] then
          seen_dirs[item.path] = true
          if initially_expanded then expanded[item.path] = true end
        end
      end
    end
    return children
  end

  -- Walks the expanded subtree from root and, for every expanded dir that
  -- could be a chain head/intermediate (unannotated, non-root) whose loaded
  -- children are a single unannotated dir, marks that dir expanded and fires
  -- on_expand. Idempotent across renders; chains converge incrementally as
  -- async data (e.g. Explorer's scan_dir) arrives between renders.
  local function extend_chains()
    if not flatten then return end
    local function walk(parent_entry, path)
      if path ~= root_path and not expanded[path] then return end
      local kids = wrapped_get_children(path)
      if not kids then return end
      local can_chain = (parent_entry ~= nil) and not has_annotations(parent_entry)
      if can_chain and #kids == 1 and kids[1].is_dir and not has_annotations(kids[1]) then
        local only = kids[1]
        if not expanded[only.path] then
          expanded[only.path] = true
          seen_dirs[only.path] = true
          if on_expand then on_expand(only.path) end
        end
      end
      for _, kid in ipairs(kids) do
        if kid.is_dir and expanded[kid.path] then
          walk(kid, kid.path)
        end
      end
    end
    walk(nil, root_path)
  end

  local function do_render()
    render_scheduled = false
    if destroyed then return end
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    extend_chains()

    local winid = find_winid()

    -- Save topline before replacing buffer content; nvim_buf_set_lines can
    -- reset the viewport, causing a visible jump on every re-render.
    local saved_topline = winid and vim.api.nvim_win_call(winid, function()
      return vim.fn.winsaveview().topline
    end) or nil

    local cursor_path
    if sticky_cursor_path then
      cursor_path = sticky_cursor_path
    elseif winid then
      local row = vim.api.nvim_win_get_cursor(winid)[1]
      local e = entries[row]
      if e then cursor_path = e.path end
    end

    local built = render.build({
      root_path = root_path,
      expanded = expanded,
      get_children = wrapped_get_children,
      flatten = flatten,
    })

    apply_winbar(winid)

    entries = built.entries
    path_to_row = built.path_to_row

    vim.bo[bufnr].modifiable = true
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, built.lines)
    vim.bo[bufnr].modifiable = false

    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    for _, h in ipairs(built.highlights) do
      pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, h.row - 1, h.col_start, {
        end_col = h.col_end,
        hl_group = h.hl,
      })
    end

    if winid and cursor_path then
      local row = row_for_path_or_ancestor(cursor_path)
      if row then
        pcall(vim.api.nvim_win_set_cursor, winid, { row, 0 })
        -- Restore topline only when the cursor row is still within the
        -- previously visible range; this keeps the viewport steady for
        -- in-place re-renders while letting it scroll when the cursor moves
        -- to a new position (e.g. a renamed file that changed sort order).
        if saved_topline then
          local win_height = vim.api.nvim_win_get_height(winid)
          if row >= saved_topline and row <= saved_topline + win_height - 1 then
            vim.api.nvim_win_call(winid, function()
              vim.fn.winrestview({ topline = saved_topline })
            end)
          end
        end
        if sticky_cursor_path and path_to_row[sticky_cursor_path] then
          sticky_cursor_path = nil
        end
      end
    end

    if on_render then on_render() end
  end

  local function schedule_render()
    if render_scheduled or destroyed then return end
    render_scheduled = true
    vim.schedule(do_render)
  end

  local handle = {}

  function handle:render() schedule_render() end

  function handle:expand(path)
    if expanded[path] then return end
    expanded[path] = true
    seen_dirs[path] = true
    if on_expand then on_expand(path) end
    schedule_render()
  end

  function handle:collapse(path)
    if not expanded[path] then return end
    expanded[path] = nil
    if on_collapse then on_collapse(path) end
    schedule_render()
  end

  function handle:reveal(path)
    if not path or path == '' then return end
    sticky_cursor_path = path
    local p = path_parent(path)
    while p and p ~= root_path do
      if not expanded[p] then
        expanded[p] = true
        seen_dirs[p] = true
        if on_expand then on_expand(p) end
      end
      p = path_parent(p)
    end
    schedule_render()
  end

  function handle:toggle_flatten()
    flatten = not flatten
    schedule_render()
  end

  function handle:set_root_label(label)
    root_label = label
    apply_winbar(find_winid())
  end

  function handle:cursor_entry()
    local w = find_winid()
    if not w then return nil end
    local row = vim.api.nvim_win_get_cursor(w)[1]
    return entries[row]
  end

  function handle:destroy()
    destroyed = true
    pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns, 0, -1)
    pcall(vim.keymap.del, 'n', '<Tab>', { buffer = bufnr })
    pcall(vim.keymap.del, 'n', '<CR>', { buffer = bufnr })
    if on_select then
      pcall(vim.keymap.del, 'n', '<C-v>', { buffer = bufnr })
      pcall(vim.keymap.del, 'n', '<C-x>', { buffer = bufnr })
      pcall(vim.keymap.del, 'n', '<C-t>', { buffer = bufnr })
    end
  end

  vim.keymap.set('n', '<Tab>', function()
    if destroyed then return end
    local winid = find_winid()
    if not winid then return end
    local row = vim.api.nvim_win_get_cursor(winid)[1]
    local e = entries[row]
    if not (e and e.is_dir) then return end
    if e.chain then
      if expanded[e.path] then
        for i = #e.chain, 1, -1 do
          local seg = e.chain[i]
          if expanded[seg] then
            expanded[seg] = nil
            if on_collapse then on_collapse(seg) end
          end
        end
      else
        for _, seg in ipairs(e.chain) do
          if not expanded[seg] then
            expanded[seg] = true
            seen_dirs[seg] = true
            if on_expand then on_expand(seg) end
          end
        end
      end
      schedule_render()
    else
      if expanded[e.path] then
        handle:collapse(e.path)
      else
        handle:expand(e.path)
      end
    end
  end, { buffer = bufnr, nowait = true, silent = true })

  vim.keymap.set('n', '<CR>', function()
    if destroyed then return end
    local winid = find_winid()
    if not winid then return end
    local row = vim.api.nvim_win_get_cursor(winid)[1]
    local e = entries[row]
    if not e or e.path == root_path then return end
    if e.is_dir then
      if e.chain then
        if expanded[e.path] then
          for i = #e.chain, 1, -1 do
            local seg = e.chain[i]
            if expanded[seg] then
              expanded[seg] = nil
              if on_collapse then on_collapse(seg) end
            end
          end
        else
          for _, seg in ipairs(e.chain) do
            if not expanded[seg] then
              expanded[seg] = true
              seen_dirs[seg] = true
              if on_expand then on_expand(seg) end
            end
          end
        end
        schedule_render()
      else
        if expanded[e.path] then
          handle:collapse(e.path)
        else
          handle:expand(e.path)
        end
      end
    elseif on_select then
      on_select(e, 'edit')
    end
  end, { buffer = bufnr, nowait = true, silent = true })

  if on_select then
    for _, spec in ipairs({
      { key = '<C-v>', action = 'vsplit' },
      { key = '<C-x>', action = 'hsplit' },
      { key = '<C-t>', action = 'tab' },
    }) do
      local action = spec.action
      vim.keymap.set('n', spec.key, function()
        if destroyed then return end
        local winid = find_winid()
        if not winid then return end
        local row = vim.api.nvim_win_get_cursor(winid)[1]
        local e = entries[row]
        if not e or e.is_dir or e.path == root_path then return end
        on_select(e, action)
      end, { buffer = bufnr, nowait = true, silent = true })
    end
  end

  return handle
end

return M
