return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-g>', ':Git<CR>', { desc = 'Git Status Window' })
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git [s]tatus' })
      vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = 'Git [a]dd current file' })
      vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git [c]ommit' })
      vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { desc = 'Git [P]ush' })
      vim.keymap.set('n', '<leader>gm', ':Gvdiffsplit!<CR>', { desc = 'Git [m]erge conflicts (3-way)' })
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-S-g>', ':GBrowse<CR>', { desc = 'Open File on GitHub' })
    end,
  },
  'tpope/vim-rhubarb',
}
