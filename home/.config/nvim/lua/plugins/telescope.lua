vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", {
                link = "Comment"
            })
        end)
    end
})

local function filename_first(opts, path)
    local tail = require("telescope.utils").path_tail(path)
    local root = vim.fs.dirname(path)
    if root == "." then
        return tail
    end
    return string.format("%s\t\t%s", tail, root)
end

-- Fuzzy Finder (files, lsp, etc)
return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end
    }, {"nvim-telescope/telescope-ui-select.nvim"}, {
        "nvim-tree/nvim-web-devicons",
        enabled = vim.g.have_nerd_font
    }},
    config = function()
        require("telescope").setup({
            defaults = {
                path_display = filename_first,
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    preview_cutoff = 180,
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.5,
                        results_width = 0.5
                    }
                },
                extensions_list = {"fzf"},
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    }
                }
            },
            pickers = {
                live_grep = {
                    additional_args = function()
                        return {"--ignore-vcs", "--ignore-global", "--hidden", "--iglob", "!.git/*"}
                    end
                }
            },
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown()}
            }
        })

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>sb", builtin.buffers, {
            desc = "[S]earch [B]uffers"
        })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {
            desc = "[S]earch [D]iagnostics"
        })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
            desc = "[S]earch [H]elp"
        })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, {
            desc = "[S]earch [K]eymaps"
        })
        vim.keymap.set("n", "<leader>so", builtin.oldfiles, {
            desc = '[S]earch [O]ld Files'
        })
        vim.keymap.set("n", "<leader>sr", builtin.resume, {
            desc = "[S]earch [R]esume"
        })

        vim.keymap.set("n", "<leader>sf", function()
          print("find files")
            builtin.find_files({
              hidden = true,
            })
        end, {
            desc = "[S]earch [F]iles"
        })

        vim.keymap.set("n", "<leader>sg", function()
          print("live grep")
            builtin.live_grep({
                additional_args = function()
                  print("additional args")
                  return {"--ignore-vcs", "--ignore-global", "--hidden", "--iglob", "!.git/*"}
                end
            })
        end, {
            desc = "[S]earch by [G]rep"
        })

        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false
            }))
        end, {
            desc = "Search in current buffer"
        })
    end
};
