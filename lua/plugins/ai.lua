vim.pack.add({
	"https://github.com/NickvanDyke/opencode.nvim",
})

vim.g.opencode_opts = {}
vim.opt.autoread = true

-- stylua: ignore start
vim.keymap.set('n', '<leader>at', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<leader>aA', function() require('opencode').ask() end, { desc = 'Ask opencode' })
vim.keymap.set('n', '<leader>aa', function() require('opencode').ask('@cursor: ') end, { desc = 'Ask opencode about this' })
vim.keymap.set('v', '<leader>aa', function() require('opencode').ask('@selection: ') end, { desc = 'Ask opencode about selection' })
vim.keymap.set('n', '<leader>an', function() require('opencode').command('session_new') end, { desc = 'New opencode session' })
vim.keymap.set('n', '<leader>ay', function() require('opencode').command('messages_copy') end, { desc = 'Copy last opencode response' })
vim.keymap.set('n', '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, { desc = 'Messages half page up' })
vim.keymap.set('n', '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, { desc = 'Messages half page down' })
vim.keymap.set({ 'n', 'v' }, '<leader>as', function() require('opencode').select() end, { desc = 'Select opencode prompt' })
vim.keymap.set('n', '<leader>ae', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
