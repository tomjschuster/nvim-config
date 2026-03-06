return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      local ai = require 'mini.ai'

      local gen_spec = ai.gen_spec
      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          -- Integrate Tree-sitter queries for function and class
          f = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      local git = require 'mini.git'
      git.setup {
        -- use :Git from fugitive
        job = {
          command = false,
        },
      }

      local diff = require 'mini.diff'

      diff.setup {
        view = {
          style = 'sign',
          signs = { add = '▎', change = '▎', delete = '➤' },
        },
      }

      vim.keymap.set('n', '<leader>gb', function()
        git.show_range_history()
      end, { desc = 'Git [b]lame (inline history)' })

      vim.keymap.set('n', '<leader>ghp', function()
        diff.toggle_overlay()
      end, { desc = 'Git [h]unk [p]eek (overlay)' })
    end,
  },
}
