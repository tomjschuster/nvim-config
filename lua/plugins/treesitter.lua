local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'elixir',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'sql',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    priority = 1100,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if not lang or lang == '' then
            return
          end
          local ok = pcall(vim.treesitter.start, args.buf, lang)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
      local move = require 'nvim-treesitter-textobjects.move'

      local selects = {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for lhs, capture in pairs(selects) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select_textobject(capture, 'textobjects')
        end)
      end

      local moves = {
        [']m'] = { 'goto_next_start', '@function.outer' },
        [']M'] = { 'goto_next_end', '@function.outer' },
        ['[m'] = { 'goto_previous_start', '@function.outer' },
        ['[M'] = { 'goto_previous_end', '@function.outer' },
        [']]'] = { 'goto_next_start', '@class.outer' },
        [']['] = { 'goto_next_end', '@class.outer' },
        ['[['] = { 'goto_previous_start', '@class.outer' },
        ['[]'] = { 'goto_previous_end', '@class.outer' },
      }
      for lhs, spec in pairs(moves) do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move[spec[1]](spec[2], 'textobjects')
        end)
      end
    end,
  },
}
