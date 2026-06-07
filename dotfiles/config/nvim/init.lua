require 'core.options'
require 'core.keymaps'

vim.pack.add({
  "https://github.com/shaunsingh/nord.nvim",
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  -- dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-mini/mini.nvim",
  -- "https://github.com/stevearc/oil.nvim",
  -- "https://github.com/moll/vim-bbye", -- used by bufferline
  -- "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  -- "nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  "https://github.com/nvim-telescope/telescope.nvim",

})

require 'plugins.colortheme'
require 'plugins.neo-tree'
-- require 'plugins.oil'
-- require 'plugins.bufferline'
require 'plugins.lualine'
require 'plugins.treesitter'
require 'plugins.telescope'
require 'plugins.lsp'

