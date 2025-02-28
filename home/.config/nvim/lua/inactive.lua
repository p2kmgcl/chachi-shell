local ns_id = vim.api.nvim_create_namespace("InactiveWindow")

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    vim.api.nvim_win_set_hl_ns(0, 0)
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.api.nvim_win_set_hl_ns(0, ns_id)

    local color = ""
    if vim.api.nvim_get_option_value("background", { scope = "global" }) == "dark" then
      color = require("catppuccin.palettes.mocha").overlay2
    else
      color = require("catppuccin.palettes.latte").overlay0
    end

    for _, hl_group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl_value = vim.api.nvim_get_hl(0, { name = hl_group, link = false })

      if
        (hl_value.fg or hl_value.bg)
        and not vim.startswith(hl_group, "diff")
        and not vim.startswith(hl_group, "EndOfBuffer")
        and not vim.startswith(hl_group, "lualine")
        and not vim.startswith(hl_group, "Pmenu")
        and not vim.startswith(hl_group, "Redraw")
        and not vim.startswith(hl_group, "SignColumn")
        and not vim.startswith(hl_group, "Status")
        and not vim.startswith(hl_group, "TabLine")
        and not vim.startswith(hl_group, "Telescope")
        and not vim.startswith(hl_group, "VertSplit")
        and not vim.startswith(hl_group, "WhichKey")
      then
        vim.api.nvim_set_hl(ns_id, hl_group, { fg = color, bg = hl_value.bg })
      end
    end
  end,
})
