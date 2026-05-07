return {
  {
    'olimorris/codecompanion.nvim',
    version = '^19.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
      },
      'j-hui/fidget.nvim',
      'lalitmee/codecompanion-spinners.nvim',
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'claude_code',
          --  adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'claude_proxy',
        },
      },
      opts = {
        log_level = 'DEBUG',
      },
      display = {
        diff = {
          enabled = true,
          --          provider = 'mini_diff',
        },
      },
      extensions = {
        spinner = {
          opts = {
            style = 'fidget',
          },
        },
      },
    },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[A]I [A]ctions (Menu)' },
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = '[A]I [C]hat Toggle' },
      { '<leader>an', '<cmd>CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = '[A]I [N]ew Chat' },
      { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = '[A]I [I]nline Prompt' },
      { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'Add selection to AI Chat' },
    },
  },
}
