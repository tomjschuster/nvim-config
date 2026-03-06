return {
  require 'colors.cobalt2',
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      filetypes = { 'html', 'css', 'javascript', 'typescript', 'lua' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like "Blue" (usually annoying in JS)
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = 'background', -- Set the display mode: 'foreground', 'background', 'virtualtext'
        tailwind = true, -- Support tailwind colors (just in case)
        virtualtext = '■',
      },
    },
  },
}
