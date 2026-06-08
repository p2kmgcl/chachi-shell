local view = require('a-side.view')

vim.keymap.set('n', '<leader>aa', view.toggle, { desc = 'a-side: toggle' })
vim.keymap.set('n', '<leader>ab', function() view.focus('buffers') end, { desc = 'a-side: focus buffers' })
vim.keymap.set('n', '<leader>ae', function() view.focus('explorer') end, { desc = 'a-side: focus explorer' })
vim.keymap.set('n', '<leader>ag', function() view.focus('git') end, { desc = 'a-side: focus git' })
vim.keymap.set('n', '<leader>a?', function()
  local ri = require('a-side.decorators.refresh_indicators')
  ri.enabled = not ri.enabled
  vim.notify('a-side: refresh indicators ' .. (ri.enabled and 'on' or 'off'))
end, { desc = 'a-side: toggle refresh indicators' })
