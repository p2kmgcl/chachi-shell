local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>fd"] = { ":Telescope diagnostics<CR>", "show diagnostics in Telescope" },
  },
}

return M
