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

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      local git = require 'mini.git'
      git.setup {
        -- Setting command to false prevents mini.git from creating :Git
        job = {
          command = false,
        },
      }

      local diff = require 'mini.diff'

      diff.setup {
        view = {
          -- Options: 'sign' (default) or 'number'
          style = 'sign',
          signs = { add = '▎', change = '▎', delete = '➤' },
        },
      }

      vim.keymap.set('n', '<leader>gb', function()
        git.show_range_history()
      end, { desc = 'Git [b]lame (inline history)' })

      -- Show Diff of current hunk in a popup
      vim.keymap.set('n', '<leader>ghp', function()
        diff.toggle_overlay()
      end, { desc = 'Git [h]unk [p]eek (overlay)' })
    end,
  },
}
