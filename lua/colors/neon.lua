return {
  {
    'rafamadriz/neon',
    priority = 1000,
    lazy = false,
    config = function(_, _)
      local c = require 'neon.colors'

      vim.g.neon_overrides = {
        ['@string.special.symbol'] = { fg = c.dark_cyan },
        ['@function'] = { fg = c.purple },
        ['@function.call'] = { fg = c.violet },
      }

      vim.g.neon_italic_keyword = true

      require('neon').colorscheme()
    end,
  },
}
