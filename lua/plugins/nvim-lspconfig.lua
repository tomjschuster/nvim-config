return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- 1. Setup Capabilities (Blink)
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- 2. Define Servers
      -- servers managed by Mason
      local servers = {
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      if vim.fn.executable 'gleam' == 1 then
        vim.lsp.config('gleam', {
          cmd = { 'gleam', 'lsp' },
          filetypes = { 'gleam' },
          root_markers = { 'gleam.toml' },
          capabilities = capabilities,
        })
        vim.lsp.enable 'gleam'
      end

      -- 3. Diagnostic & UI Config
      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          prefix = '●', -- Or use your Nerd Font icons
          format = function(diagnostic)
            -- Extract only the first line of the message
            local first_line = diagnostic.message:match '([^\n]+)'
            return first_line or diagnostic.message
          end,
        },
      }

      -- 4. Global LSP Mappings (LspAttach)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')

          map('<leader>e', function()
            vim.diagnostic.open_float { border = 'rounded' }
          end, 'Show [E]rror detail (Float)')

          map(']d', function()
            vim.diagnostic.jump { count = 1, float = true }
          end, 'Next [D]iagnostic')

          map('[d', function()
            vim.diagnostic.jump { count = -1, float = true }
          end, 'Previous [D]iagnostic')

          map(']e', function()
            vim.diagnostic.jump {
              count = 1,
              severity = vim.diagnostic.severity.ERROR,
              float = true,
            }
          end, 'Next [E]rror')

          map(']d', function()
            vim.diagnostic.goto_next()
            -- This opens the float automatically after jumping
            vim.diagnostic.open_float(nil, { focusable = false })
          end, 'Next [D]iagnostic')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method 'textDocument/inlayHint' then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- 5. Mason & Tool Installation
      -- We explicitly list tools Mason should handle. (No Gleam here!)
      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, { 'stylua' })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

            -- Use the specific server setup to avoid global index warnings
            local configs = require 'lspconfig.configs'
            if configs[server_name] then
              configs[server_name].setup(server_opts)
            end
          end,
        },
      }
    end,
  },
}
