return {
  {
    'olimorris/codecompanion.nvim',
    version = '^19.0.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'franco-ruggeri/codecompanion-spinner.nvim',
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
        action_notification = true,
        diff = {
          enabled = true,
          provider = 'mini_diff',
          layout = 'vertical',
          word_highlights = {
            additions = true,
            deletions = true,
          },
        },
      },
      extensions = {
        spinner = {},
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
