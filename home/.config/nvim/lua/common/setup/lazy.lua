-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}

-- Import plugins from [scope].plugins
for name in vim.fs.dir(vim.fn.stdpath("config") .. "/lua") do
  local spec_files = vim.fs.find(function(specName)
    return specName:match(".lua$")
  end, {
    type = "file",
    path = vim.fn.stdpath("config") .. "/lua/" .. name .. "/plugins",
  })
  if #spec_files > 0 then
    table.insert(spec, { import = name .. ".plugins" })
  end
end

require("lazy").setup({
  spec = spec,
  install = {
    colorscheme = { "habamax" },
  },
  checker = {
    enabled = true,
    frequency = 60 * 60 * 24 * 14, -- every 2 weeks in seconds
  },
  change_detection = {
    enabled = false,
  },
})

vim.cmd([[colorscheme catppuccin-latte]])
