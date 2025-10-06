return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
    { '<leader>r', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>b', ':Neotree toggle show buffers right<CR>', desc = 'Toggle buffers', silent = true },
    { '<leader>g', ':Neotree float git_status<CR>', desc = 'Git status', silent = true },
  },
  config = function()
    require('neo-tree').setup({
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
	    ["J"] = function(state)
              local tree = state.tree
              local node = tree:get_node()
              local siblings = tree:get_nodes(node:get_parent_id())
              local renderer = require('neo-tree.ui.renderer')
              renderer.focus_node(state, siblings[#siblings]:get_id())
            end,
            ["K"] = function(state)
              local tree = state.tree
              local node = tree:get_node()
              local siblings = tree:get_nodes(node:get_parent_id())
              local renderer = require('neo-tree.ui.renderer')
              renderer.focus_node(state, siblings[1]:get_id())
            end
          },
        },
        filtered_items = {
	  visible = true,
          hide_dotfiles = false,
	  hide_hidden = false,
        }
      },
      default_component_configs = {
        indent = {
          with_markers = false,
        },
      },
    })
  end
}

