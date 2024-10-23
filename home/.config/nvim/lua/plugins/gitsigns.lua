-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "█" },
      change = { text = "█" },
      delete = { text = "█" },
      topdelete = { text = "█" },
      changedelete = { text = "█" },
    },
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 100,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next [h]unk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous [h]unk")

      map("n", "<leader>ga", gs.stage_hunk, "[G]it [a]dd hunk")
      map("n", "<leader>gd", gs.preview_hunk, "[G]it [d]iff hunk")
      map("n", "<leader>gu", gs.undo_stage_hunk, "[G]it [u]undo add hunk")
      map("v", "<leader>ga", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[G]it [a]dd hunk")

      map("n", "<leader>tb", function()
        vim.cmd("Gitsigns toggle_current_line_blame")
      end, "[T]oggle git [b]lame")
    end,
  },
}
