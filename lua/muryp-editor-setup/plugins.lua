local todoComment = require 'muryp-editor-setup.todoComment'

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

return {
  {
    'nvim-pack/nvim-spectre', -- multi file replace text
    build = false,
    cmd = 'Spectre',
    opts = { open_cmd = 'noswapfile vnew' },
    -- stylua: ignore
    keys = {
      { "<leader>Sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    Lazy = true,
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
  },
  {
    'muryp/muryp-git-setup.nvim',
    import = 'muryp-git-setup/plugin',
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = todoComment,
  },
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      mappings = {
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
      },
    },
    keys = {
      {
        '<leader>tp',
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            print 'Disabled auto pairs'
          else
            print 'Enabled auto pairs'
          end
        end,
        desc = 'Toggle Auto Pairs',
      },
    },
  },
  require 'muryp-editor-setup.formatter',
  require 'muryp-editor-setup.neotree',
}
