-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    --    require 'colors.cobalt2',
    {
      'rafamadriz/neon',
      --      dir = '~/.local/share/nvim/lazy/neon/',
      priority = 1000,
      lazy = false,
      config = function(neon, opts)
        vim.g.neon_overrides = { SpecialChar = { fg = require('neon.colors').purple } }
        require('neon').colorscheme()
      end,
    },

    'NMAC427/guess-indent.nvim',
    'cohama/lexima.vim',
    { import = 'plugins' },
  },
  install = { colorscheme = { 'neon' } },
  checker = { enabled = true, notify = false },
}
