local function apply_colorscheme()
  if vim.o.background == "dark" then
    vim.cmd.colorscheme("github_dark_colorblind")
  else
    vim.cmd.colorscheme("github_light_colorblind")
  end
end

vim.api.nvim_create_autocmd("OptionSet", {
  group = vim.api.nvim_create_augroup("auto-dark-mode", { clear = true }),
  pattern = "background",
  callback = apply_colorscheme,
})

apply_colorscheme()
