local view = require('a-side.view')

vim.keymap.set('n', '<leader>aa', view.toggle, { desc = 'a-side: toggle' })
vim.keymap.set('n', '<leader>ab', function() view.focus('buffers') end, { desc = 'a-side: focus buffers' })
vim.keymap.set('n', '<leader>ae', function() view.focus('explorer') end, { desc = 'a-side: focus explorer' })
vim.keymap.set('n', '<leader>ag', function() view.focus('git') end, { desc = 'a-side: focus git' })
