local function get_root_dir(bufnr, cb)
  local fname = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))

  local ts_root = vim.fs.find("tsconfig.json", { upward = true, path = fname })[1]
  local yarn_root = vim.fs.find("yarn.lock", { upward = true, path = fname })[1]
  local npm_root = vim.fs.find("package-lock.json", { upward = true, path = fname })[1]

  if yarn_root then
    cb(vim.fn.fnamemodify(yarn_root, ":h"))
  elseif npm_root then
    cb(vim.fn.fnamemodify(npm_root, ":h"))
  elseif ts_root then
    cb(vim.fn.fnamemodify(ts_root, ":h"))
  end
end

return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = get_root_dir,
}
