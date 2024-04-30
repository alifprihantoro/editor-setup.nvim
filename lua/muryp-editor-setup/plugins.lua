local todoComment = require "muryp-editor-setup.todoComment"

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
    'nvim-neo-tree/neo-tree.nvim',
    Lazy = true,
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'muryp/muryp-git-setup.nvim',
    import = 'muryp-git-setup/plugin'
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = todoComment,
  },
}