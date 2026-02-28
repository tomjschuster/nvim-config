-- Autoformat
local function get_format_opts()
  local opts = { async = true, lsp_format = 'fallback' }

  -- If in visual mode, format only the selection
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    local start_line = vim.fn.line 'v'
    local end_line = vim.fn.line '.'
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    opts.range = { start = { start_line, 0 }, ['end'] = { end_line, 999999 } }
  end
  return opts
end

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format(get_format_opts(), function(err)
            if err then
              vim.notify(tostring(err), vim.log.levels.ERROR)
            else
              vim.cmd 'echohl ConformSuccess'
              vim.cmd 'echom "✓ Formatted"'
              vim.cmd 'echohl None'
            end
          end)
        end,
        mode = { 'n', 'v' },
        desc = '[F]ormat buffer or range',
      },
      {
        '<leader>fs',
        function()
          require('conform').format(get_format_opts(), function(err)
            if err then
              vim.notify(tostring(err), vim.log.levels.ERROR)
            else
              vim.cmd 'write'
              vim.cmd 'echohl ConformSuccess'
              vim.cmd 'echom "✓ Formatted & Saved"'
              vim.cmd 'echohl None'
            end
          end)
        end,
        mode = { 'n', 'v' },
        desc = '[F]ormat and [S]ave buffer',
      },
    },
    config = function()
      -- Define custom highlight group for format success
      vim.api.nvim_set_hl(0, 'ConformSuccess', { fg = '#50fa7b', italic = true })

      require('conform').setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true, elixir = true, heex = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters = {
          mix_umbrella = {
            meta = {
              url = 'https://hexdocs.pm/mix/main/Mix.Tasks.Format.html',
              description = 'Format Elixir files in a using the mix format command.',
            },
            command = 'bash',
            args = {
              '-c',
              -- mix format outputs compilation logs to stdout (e.g. "Compiling ...")
              -- which pollutes the buffer. We filter these lines out.
              -- We also use pipefail so that if mix format fails (e.g. unchecked deps),
              -- the whole pipeline fails and conform can report the error.
              'set -o pipefail; mix format --stdin-filename "$1" - | sed -e "/^==>/d" -e "/^Compiling/d" -e "/^Generated/d"',
              '--',
              '$FILENAME',
            },
            cwd = require('conform.util').root_file {
              'apps',
              '.formatter.exs',
              'mix.exs',
            },
            timeout_ms = 5000,
          },
        },
        formatters_by_ft = {
          gleam = { 'gleam' },
          lua = { 'stylua' },
          elixir = { 'mix_umbrella' },
          heex = { 'mix_umbrella' },
        },
      }
    end,
  },
}
