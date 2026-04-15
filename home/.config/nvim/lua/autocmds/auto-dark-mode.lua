local function apply_colorscheme()
  if vim.o.background == "dark" then
    vim.cmd("colorscheme github_dark_colorblind")
  else
    vim.cmd("colorscheme github_light_colorblind")
  end
end

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = apply_colorscheme,
})

apply_colorscheme()
