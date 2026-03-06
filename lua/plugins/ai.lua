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
      adapters = {
        http = {
          bedrock = function()
            local orig_form_messages = require('codecompanion.adapters.http.anthropic').handlers.form_messages

            return require('codecompanion.adapters').extend('anthropic', {
              url = 'https://bedrock-runtime.${aws_region}.amazonaws.com/model/${model}/invoke',
              env = {
                api_key = function()
                  return ''
                end,
                model = 'schema.model.default',
                aws_region = 'AWS_REGION',
                bearer_token = 'AWS_BEARER_TOKEN_BEDROCK',
              },
              headers = {
                ['content-type'] = 'application/json',
                ['anthropic-version'] = '2023-06-01',
                ['x-api-key'] = '',
                ['Authorization'] = 'Bearer ${bearer_token}',
              },
              opts = {
                stream = false,
              },
              handlers = {
                setup = function(self)
                  -- Bedrock doesn't accept 'model' or 'stream' in the body
                  self.parameters = self.parameters or {}
                  self.parameters.model = nil
                  self.parameters.stream = nil
                  return true
                end,
                -- Wrap form_messages to adapt for Bedrock
                form_messages = function(self, messages)
                  local result = orig_form_messages(self, messages)
                  result.cache_control = nil
                  result.anthropic_version = 'bedrock-2023-05-31'
                  return result
                end,
              },
              schema = {
                model = {
                  order = 1,
                  mapping = 'parameters',
                  type = 'enum',
                  desc = 'Bedrock model ID',
                  default = 'us.anthropic.claude-sonnet-4-6',
                  choices = {
                    'us.anthropic.claude-sonnet-4-6',
                    'us.anthropic.claude-haiku-4-5-20251001-v1:0',
                    'us.anthropic.claude-opus-4-6-v1',
                  },
                },
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = 'claude_code',
          --  adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'bedrock',
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
