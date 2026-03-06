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
          adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'anthropic',
          model = 'claude-3-5-haiku-latest', -- Use the fast/cheap model for inline
        },
      },
      display = {
        diff = {
          enabled = true,
          provider = 'mini_diff',
        },
      },
      extensions = {
        spinner = {
          style = 'fidget',
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
