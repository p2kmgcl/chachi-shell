-- Similar to vim.fs.find({}) with multiple file names,
-- But it prefers the first file_name in the list instead of the nearest one
return function(file_names)
  return function(bufnr, cb)
    local fname = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))
    for _, file_name in ipairs(file_names) do
      local root_path = vim.fs.find(file_name, { upward = true, path = fname })[1]
      if root_path then
        cb(vim.fn.fnamemodify(root_path, ":h"))
        return
      end
    end
  end
end
