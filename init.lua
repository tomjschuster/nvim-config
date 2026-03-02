vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('i', '<C-a>', '<Home>', { desc = 'Go to the beginning of the line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'Go to the end of the line' })

vim.keymap.set('n', 'H', '<Home>', { desc = 'Go to the beginning of the line' })
vim.keymap.set('n', 'L', '<End>', { desc = 'Go to the end of the line' })

-- NOTE: This won't work in all terminal emulators/tmux/etc.
vim.keymap.set('n', 't', '<Cmd>vsplit | terminal<CR>', { desc = 'Terminal' })
vim.keymap.set('n', '<S-T>', '<Cmd>split | terminal<CR>', { desc = 'Terminal (horizontal)' })

vim.keymap.set('n', '<leader>d', function()
  local ts = require 'nvim-treesitter.ts_utils'
  local node = ts.get_node_at_cursor()
  if node then
    print('Node type: ' .. node:type())
    print('Parent: ' .. (node:parent() and node:parent():type() or 'none'))
  end
end)

vim.keymap.set('n', '<C-S-s>', function()
  local ts_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
  if ts_ok then
    local node = ts_utils.get_node_at_cursor()
    if node then
      print('Node type: ' .. node:type())

      -- Get all captures at cursor
      local bufnr = vim.api.nvim_get_current_buf()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local captures = vim.treesitter.get_captures_at_pos(bufnr, row - 1, col)
      if #captures > 0 then
        for _, capture in ipairs(captures) do
          print('Capture: @' .. capture.capture)
        end
      end
    end
  end
end, { desc = 'Debug syntax highlighting at cursor' })

-- quickfix list delete keymap
function Remove_qf_item()
  local curqfidx = vim.fn.line '.'
  local qfall = vim.fn.getqflist()

  -- Return if there are no items to remove
  if #qfall == 0 then
    return
  end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, 'r')

  -- Reopen quickfix window to refresh the list
  vim.cmd 'copen'

  -- If not at the end of the list, stay at the same index, otherwise, go one up.
  local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)

  -- Set the cursor position directly in the quickfix window
  local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
  vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end

vim.cmd 'command! RemoveQFItem lua Remove_qf_item()'
vim.api.nvim_command 'autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<cr>'

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.o.termguicolors = true
vim.g.have_nerd_font = true

-- mode is shown in status via mini
vim.o.showmode = false

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('+', vim.fn.expand '%:.')
end, { noremap = true, silent = true, desc = 'Copy current buffer path' })

vim.o.breakindent = true
vim.o.undofile = true
vim.o.autoread = true

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('AutoRefresh', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true
vim.o.exrc = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'VimLeavePre' }, {
  pattern = '*',
  callback = function(opts)
    local buf = opts.buf
    -- Only act on codecompanion chat buffers
    if vim.bo[buf].filetype == 'codecompanion' then
      -- e.g. in .nvim.lua: vim.g.codecompanion_chat_dir = "docs/ai_chats"
      local save_dir = vim.g.codecompanion_chat_dir

      if not save_dir then
        return
      end

      if not vim.startswith(save_dir, '/') then
        save_dir = vim.fn.getcwd() .. '/' .. save_dir
      end

      -- Ensure the directory exists
      if vim.fn.isdirectory(save_dir) == 0 then
        vim.fn.mkdir(save_dir, 'p')
      end

      -- 1. Check if we already assigned a file path to this specific buffer
      local ok, save_path = pcall(vim.api.nvim_buf_get_var, buf, 'chat_save_path')

      -- 2. If not, generate one and save it as a buffer-local variable
      if not ok or save_path == nil then
        local timestamp = os.date '%Y-%m-%d_%H-%M-%S'
        -- Optional: You could parse line 1 to get a title, but timestamp is safer
        save_path = string.format('%s/chat_%s.md', save_dir, timestamp)
        vim.api.nvim_buf_set_var(buf, 'chat_save_path', save_path)
      end

      -- 3. Grab the current state of the buffer (including any modifications you made)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- 4. Overwrite the file with the current state
      local file = io.open(save_path, 'w')
      if file then
        file:write(table.concat(lines, '\n'))
        file:close()
      end
    end
  end,
})

vim.env.GPG_TTY = vim.fn.expand '$TTY'

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99 -- Prevents files from opening with all folds closed

require 'config.lazy'
