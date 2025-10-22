return {
  {
    'lalitmee/cobalt2.nvim',
    event = { 'ColorSchemePre' }, -- if you want to lazy load
    dependencies = { 'tjdevries/colorbuddy.nvim', tag = 'v1.0.0' },
    init = function()
      require('colorbuddy').colorscheme 'cobalt2'

      local colors = require('cobalt2.utils').colors
      local Group = require('cobalt2.utils').Group
      local styles = require('colorbuddy').styles

      Group.new('@string.special.symbol', colors.dark_pink, nil, nil)
      Group.new('@function', colors.yellow, nil, nil)
      Group.new('@function.call', colors.yellow, nil, nil)
      Group.new('@keyword', colors.orange, nil, nil)
      Group.new('@keyword.function', colors.orange, nil, nil)
    end,
  },
}
