vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

local function filename_first(opts, path)
  local tail = require("telescope.utils").path_tail(path)
  local root = vim.fs.dirname(path)

  if root == "." then
    return tail
  end

  return string.format("%s\t\t%s", tail, root)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        path_display = filename_first,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          preview_cutoff = 180,
          horizontal = {
            prompt_position = "top",
            preview_width = 0.5,
            results_width = 0.5,
          },
        },
        extensions_list = { "fzf" },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
      pickers = {
        grep_string = {
          additional_args = function()
            return { "--ignore", "--hidden" }
          end,
        },
        live_grep = {
          additional_args = function()
            return { "--ignore", "--hidden" }
          end,
        },
      },
    },
  },
}
