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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- servers managed by Mason
      local servers = {
        -- JS/TS (vtsls is faster and smarter than ts_ls)
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                variableTypes = { enabled = true },
              },
            },
          },
        },
        html = {},
        cssls = {},
        -- Emmet (Crucial for HTML/CSS speed)
        emmet_ls = {
          filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'eruby' },
        },
        jsonls = {},
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
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettierd', -- Faster Prettier
        'eslint_d', -- Faster ESLint
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Servers to disable (using alternatives: vtsls for TS, expert for Elixir)
      local disabled_servers = { 'ts_ls', 'elixirls' }

      require('mason-lspconfig').setup {
        handlers = {
          -- Prevent mason-lspconfig from calling setup() on disabled servers
          ts_ls = function() end,
          elixirls = function() end,
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

            require('lspconfig')[server_name].setup(server_opts)
          end,
        },
      }

      -- Defer disable to override any auto-enabled configs from nvim-lspconfig's lsp/*.lua
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          for _, name in ipairs(disabled_servers) do
            vim.lsp.enable(name, false)
          end
        end,
      })
    end,
  },
}
