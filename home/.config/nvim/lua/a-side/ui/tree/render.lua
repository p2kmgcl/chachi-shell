local annotations = require('a-side.ui.tree.annotations')
local icons = require('a-side.ui.tree.icons')

local M = {}

local INDENT = '  '

local function entry_annotation_defs(entry)
  if not entry.annotations or #entry.annotations == 0 then return {} end
  local seen = {}
  local list = {}
  for _, id in ipairs(entry.annotations) do
    local def = annotations.lookup(id)
    if def and not seen[id] then
      seen[id] = true
      list[#list + 1] = def
    end
  end
  table.sort(list, function(a, b) return a.order < b.order end)
  return list
end

local function has_annotations(entry)
  return entry.annotations and #entry.annotations > 0
end

local function try_build_chain(head, expanded, get_children)
  if has_annotations(head) then return nil end
  local segs = { head }
  local current = head
  while true do
    if not expanded[current.path] then break end
    local kids = get_children(current.path)
    if not kids or #kids ~= 1 then break end
    local only = kids[1]
    if not only.is_dir then break end
    segs[#segs + 1] = only
    current = only
    if has_annotations(only) then break end
  end
  if #segs < 2 then return nil end
  return segs
end

function M.build(opts)
  local root_path = opts.root_path
  local expanded = opts.expanded
  local get_children = opts.get_children
  local flatten = opts.flatten

  local lines = {}
  local highlights = {}
  local entries = {}
  local path_to_row = {}

  local function emit_row(item, depth, display_name, icon_entry, extra_paths)
    display_name = display_name or item.name
    icon_entry = icon_entry or item

    local indent = string.rep(INDENT, depth)
    local chevron
    if item.is_dir then
      chevron = expanded[item.path] and '▾ ' or '▸ '
    else
      chevron = '  '
    end
    local icon, icon_hl = icons.get(icon_entry)
    local prefix = indent .. chevron .. icon .. ' '
    local name_suffix = item.is_dir and '/' or ''

    local anns = entry_annotation_defs(item)
    local ann_text = ''
    if #anns > 0 then
      local parts = {}
      for _, a in ipairs(anns) do parts[#parts + 1] = a.text end
      ann_text = ' ' .. table.concat(parts, '')
    end

    local line = prefix .. display_name .. name_suffix .. ann_text
    lines[#lines + 1] = line
    local row = #lines
    entries[row] = item
    path_to_row[item.path] = row
    if extra_paths then
      for _, p in ipairs(extra_paths) do path_to_row[p] = row end
    end

    if icon_hl then
      local col_start = #indent + #chevron
      local col_end = col_start + #icon
      highlights[#highlights + 1] = {
        row = row, col_start = col_start, col_end = col_end, hl = icon_hl,
      }
    end

    if #anns > 0 then
      local ann_col = #prefix + #display_name + #name_suffix + 1
      for _, a in ipairs(anns) do
        highlights[#highlights + 1] = {
          row = row,
          col_start = ann_col,
          col_end = ann_col + #a.text,
          hl = a.hl,
        }
        ann_col = ann_col + #a.text
      end
    end
  end

  local function walk(parent_path, depth)
    local children = get_children(parent_path)
    if not children then return end
    for _, item in ipairs(children) do
      if item.is_dir then
        local chain
        if flatten and expanded[item.path] then
          chain = try_build_chain(item, expanded, get_children)
        end
        if chain then
          local tail = chain[#chain]
          local names = {}
          local chain_paths = {}
          for _, seg in ipairs(chain) do
            names[#names + 1] = seg.name
            chain_paths[#chain_paths + 1] = seg.path
          end
          local synthetic = {
            name = table.concat(names, '/'),
            path = tail.path,
            is_dir = true,
            chain = chain_paths,
            annotations = tail.annotations,
          }
          emit_row(synthetic, depth, synthetic.name,
            { is_dir = true, name = tail.name }, chain_paths)
          if expanded[tail.path] then
            walk(tail.path, depth + 1)
          end
        else
          emit_row(item, depth)
          if expanded[item.path] then
            walk(item.path, depth + 1)
          end
        end
      else
        emit_row(item, depth)
      end
    end
  end

  walk(root_path, 0)

  return {
    lines = lines,
    highlights = highlights,
    entries = entries,
    path_to_row = path_to_row,
  }
end

return M
