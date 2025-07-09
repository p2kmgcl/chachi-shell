return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- Disable automatic updates when text changes
    update_debounce = 10000, -- 10 seconds (effectively disabled during editing)
    
    -- Disable automatic git directory watching
    watch_gitdir = {
      interval = 0, -- Disable periodic checks
      follow_files = false,
    },
    
    -- Don't update signs while in insert mode
    _refresh_staged_on_update = false,
    
    -- Additional configuration to reduce interference
    max_file_length = 40000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
  
  -- Configure autocommands for debounced updates
  config = function(_, opts)
    require("gitsigns").setup(opts)
    
    -- Create an autocmd group for gitsigns refresh
    local group = vim.api.nvim_create_augroup("GitsignsRefresh", { clear = true })
    
    -- Refresh signs when leaving insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })
    
    -- Refresh signs when saving a file
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })
    
    -- Refresh signs when buffer gets focus
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })
    
    -- Refresh signs when Neovim regains focus
    vim.api.nvim_create_autocmd("FocusGained", {
      group = group,
      callback = function()
        require("gitsigns").refresh()
      end,
    })
  end,
}