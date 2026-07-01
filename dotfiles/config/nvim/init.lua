require("core.options")
require("core.keymaps")

vim.pack.add({
	"https://github.com/shaunsingh/nord.nvim",
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/oil.nvim",
	-- "https://github.com/moll/vim-bbye", -- used by bufferline
	-- "https://github.com/akinsho/bufferline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/folke/which-key.nvim",

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
})

require("plugins.colortheme")
require("plugins.neo-tree")
require("plugins.oil")
-- require 'plugins.bufferline'
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.blink")
require("plugins.lsp")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.diffview")
require("plugins.trouble")
require("plugins.whichkey")
require("plugins.review")

vim.api.nvim_create_user_command("GitChangedStaging", function()
	vim.cmd("args `git diff --name-only origin/staging...HEAD`")
end, {})
