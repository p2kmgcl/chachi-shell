local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>fd"] = { ":Telescope diagnostics<CR>", "show diagnostics in Telescope" },
    ["<leader>ff"] = { ":Telescope find_files hidden=true<CR>", "find files" },
  },
}

return M
