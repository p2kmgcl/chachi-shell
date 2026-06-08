local M = {}
local notify = require("formatters.notify")

function M.root()
  local folders = vim.lsp.buf.list_workspace_folders()
  if folders and #folders > 0 then
    return folders[1]
  end
  return vim.fn.getcwd()
end

function M.has_file(root, ...)
  for _, name in ipairs({ ... }) do
    if vim.fn.filereadable(root .. "/" .. name) == 1 then
      return true
    end
  end
  return false
end

function M.has_glob(root, pattern)
  return #vim.fn.glob(root .. "/" .. pattern, false, true) > 0
end

-- Per-session cache: "<root>\0<name>" -> cmd table | false (not found)
local pnp_cache = {}

-- Returns the command prefix to run a project-local node binary.
-- Classic node_modules: returns immediately.
-- Yarn PnP: resolves via `yarn bin` once per session (yields coroutine),
--   then runs node directly with .pnp.cjs — no yarn overhead after first call.
-- Returns nil if the binary is not available.
function M.node_bin(root, name)
  local classic = root .. "/node_modules/.bin/" .. name
  if vim.fn.filereadable(classic) == 1 then
    return { classic }
  end

  if vim.fn.filereadable(root .. "/.pnp.cjs") ~= 1 then
    return nil
  end

  local key = root .. "\0" .. name
  if pnp_cache[key] ~= nil then
    return pnp_cache[key] or nil
  end

  local co = coroutine.running()
  assert(co, "node_bin PnP resolution must be called from a coroutine")
  vim.system({ "yarn", "bin", name }, { cwd = root, text = true }, function(result)
    if result.code == 0 then
      local path = result.stdout:gsub("%s+$", "")
      local cmd = { "node", "--no-warnings", "--require", root .. "/.pnp.cjs" }
      if vim.fn.filereadable(root .. "/.pnp.loader.mjs") == 1 then
        table.insert(cmd, "--loader")
        table.insert(cmd, root .. "/.pnp.loader.mjs")
      end
      table.insert(cmd, path)
      pnp_cache[key] = cmd
    else
      pnp_cache[key] = false
    end
    vim.schedule(function() coroutine.resume(co) end)
  end)
  coroutine.yield()

  return pnp_cache[key] or nil
end

function M.has_bin(name)
  return vim.fn.executable(name) == 1
end

-- Async CLI runner — must be called from inside a coroutine.
-- Passes cwd so yarn PnP resolves packages from the project root.
function M.cli_run(cmd, cwd)
  local co = coroutine.running()
  assert(co, "cli_run must be called from a coroutine")
  vim.system(cmd, { text = true, cwd = cwd }, function(result)
    vim.schedule(function()
      coroutine.resume(co, result)
    end)
  end)
  return coroutine.yield()
end

function M.save_if_modified()
  if vim.bo.modified then
    vim.cmd("write")
  end
end

function M.reload()
  vim.cmd("silent! checktime")
end

function M.lsp_format(name)
  local clients = vim.lsp.get_clients({ bufnr = 0, name = name })
  if #clients == 0 then
    notify.warn(name .. " not active")
    return false
  end
  vim.lsp.buf.format({ bufnr = 0, async = false, filter = function(c) return c.name == name end })
  return true
end

return M
