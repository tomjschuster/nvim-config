vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('i', '<C-a>', '<Home>', { desc = 'Go to the beginning of the line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Go to the end of the line' })

vim.keymap.set('n', 't', '<Cmd>vsplit | terminal<CR>', { desc = 'Terminal' })
vim.keymap.set('n', '<S-T>', '<Cmd>split | terminal<CR>', { desc = 'Terminal (horizontal)' })

