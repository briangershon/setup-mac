require("oil").setup()

-- vim-vinegar style: open parent directory of current file
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

