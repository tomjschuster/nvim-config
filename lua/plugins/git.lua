return {
  {
    'tpope/vim-fugitive',
    config = function()
      -- Project-wide status
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-g>', ':Git<CR>', { desc = 'Git Status Window' })
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git [s]tatus' })

      -- Actions
      vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = 'Git [a]dd current file' })
      vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git [c]ommit' })
      vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { desc = 'Git [P]ush' })

      -- 3-Way Merge Conflict Resolution
      vim.keymap.set('n', '<leader>gm', ':Gvdiffsplit!<CR>', { desc = 'Git [m]erge conflicts (3-way)' })

      -- Github Browse
      vim.keymap.set({ 'n', 'v', 'i' }, '<C-S-g>', ':GBrowse<CR>', { desc = 'Open File on GitHub' })
    end,
  },
  'tpope/vim-rhubarb',
}
