return {
  'junegunn/fzf',
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function()
      vim.env.FZF_DEFAULT_COMMAND = 'ag -g ""'

      local fzf_opts = {
        style = 'full',
        border = 'rounded',
        padding = '0',
        ['input-label'] = '" Input "',
        ['header-label'] = '" File Type "',
      }

      local fzf_binds = {
        'ctrl-u:preview-up',
        'ctrl-d:preview-down',
        'ctrl-p:preview-half-page-up',
        'ctrl-n:preview-half-page-down',
        'ctrl-/:toggle-preview',
      }

      local fzf_colors = {
        border = '#aaaaaa',
        label = '#cccccc',
        ['preview-border'] = '#9999cc',
        ['preview-label'] = '#ccccff',
        ['list-border'] = '#669966',
        ['list-label'] = '#99cc99',
        ['input-border'] = '#996666',
        ['input-label'] = '#ffcccc',
        ['header-border'] = '#6699cc',
        ['header-label'] = '#99ccff',
      }

      local opts_list = {}
      for key, value in pairs(fzf_opts) do
        table.insert(opts_list, '--' .. key .. '=' .. value)
      end

      -- Add bind options separately
      for _, bind in ipairs(fzf_binds) do
        table.insert(opts_list, '--bind=' .. bind)
      end

      local color_parts = {}
      for key, value in pairs(fzf_colors) do
        table.insert(color_parts, key .. ':' .. value)
      end
      table.insert(opts_list, '--color=' .. table.concat(color_parts, ','))

      vim.env.FZF_DEFAULT_OPTS = table.concat(opts_list, ' ')

      vim.g.fzf_vim = {
        files_options = { '--border-label', ' 📁 Files ' },
        ag_options = { '--border-label', ' 🔍 Ag Search ' },
        rg_options = { '--border-label', ' 🔍 Ripgrep Search ' },
      }

      vim.keymap.set('n', '<C-p>', ':Files<CR>', { silent = true, desc = 'FZF Files' })
      vim.keymap.set('n', '<C-f>', ':Rg<CR>', { silent = true, desc = 'FZF Ripgrep search' })
      vim.keymap.set('n', '<C-S-f>', ':Ag<CR>', { silent = true, desc = 'FZF Ag search' })
    end,
  },
}
