return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-g>', ':Git<CR>', { desc = 'Open Git Status Window' })
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-S-g>', ':GBrowse<CR>', { desc = 'Open File on GitHub' })
      vim.keymap.set('n', '<leader>ga', ':Git add<CR>', { desc = 'Git Add' })
      vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git Commit' })
      vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'Git Push' })
      vim.keymap.set('n', '<leader>gd', ':Git diff <CR>', { desc = 'Git Diff Split Vertically' })
      vim.keymap.set('n', '<leader>gs', ':Gvdiffsplit <CR>', { desc = 'Git Diff Split Vertically' })
    end,
  },
  'tpope/vim-rhubarb',
}
