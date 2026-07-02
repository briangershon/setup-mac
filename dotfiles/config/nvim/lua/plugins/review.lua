-- PR review workflow: all <leader>r keymaps

local function git_ref_exists(ref)
	local result = vim.fn.system("git rev-parse --verify " .. ref .. " 2>/dev/null")
	return vim.v.shell_error == 0
end

local function get_review_base()
	local candidates = {
		"origin/staging",
		"origin/main",
		"origin/master",
		"staging",
		"main",
		"master",
	}
	for _, ref in ipairs(candidates) do
		if git_ref_exists(ref) then
			return ref
		end
	end
	return "origin/main"
end

local function open_review()
	local base = get_review_base()
	local merge_base = vim.fn.system("git merge-base HEAD " .. base):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 or merge_base == "" then
		vim.notify("Could not find merge base with " .. base, vim.log.levels.WARN)
		return
	end

	require("gitsigns").change_base(merge_base, true)

	local toplevel = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")
	local files_raw = vim.fn.system("git diff --name-only " .. merge_base .. " HEAD")
	if vim.v.shell_error ~= 0 then
		vim.notify("Could not list changed files against " .. base, vim.log.levels.WARN)
		return
	end

	local files = {}
	for file in files_raw:gmatch("[^\r\n]+") do
		table.insert(files, toplevel .. "/" .. file)
	end

	if #files == 0 then
		vim.notify("No changed files against " .. base, vim.log.levels.INFO)
		return
	end

	for i, file in ipairs(files) do
		if i == 1 then
			vim.cmd.edit(file)
		else
			vim.fn.bufadd(file)
		end
	end
end

vim.api.nvim_create_user_command("ReviewOpen", open_review, {
	desc = "Open changed files as buffers against detected base branch",
})

vim.keymap.set("n", "<leader>ro", open_review, { desc = "Review: open changed files as buffers" })

-- Git hunk navigation (gitsigns)
vim.keymap.set("n", "<leader>rn", function()
	require("gitsigns").next_hunk()
end, { desc = "Review: next hunk" })

vim.keymap.set("n", "<leader>rp", function()
	require("gitsigns").prev_hunk()
end, { desc = "Review: previous hunk" })

vim.keymap.set("n", "<leader>rh", function()
	require("gitsigns").preview_hunk()
end, { desc = "Review: preview hunk" })

vim.keymap.set("n", "<leader>rb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Review: blame line" })

-- Trouble: diagnostics, references, symbols, quickfix, loclist
vim.keymap.set("n", "<leader>rr", "<cmd>Trouble lsp_references toggle focus=true<cr>", { desc = "Review: references (Trouble)" })
vim.keymap.set("n", "<leader>rd", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Review: diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>rs", "<cmd>Trouble symbols toggle focus=true<cr>", { desc = "Review: document symbols" })
vim.keymap.set("n", "<leader>rq", "<cmd>Trouble qflist toggle focus=true<cr>", { desc = "Review: quickfix" })
vim.keymap.set("n", "<leader>rl", "<cmd>Trouble loclist toggle focus=true<cr>", { desc = "Review: location list" })
vim.keymap.set("n", "<leader>rt", "<cmd>Trouble toggle<cr>", { desc = "Review: toggle Trouble" })

-- LSP: jump to references (Telescope picker), implementation, definition
vim.keymap.set("n", "<leader>rR", function()
	require("telescope.builtin").lsp_references()
end, { desc = "Review: references (Telescope)" })

vim.keymap.set("n", "<leader>ri", vim.lsp.buf.implementation, { desc = "Review: implementation" })
vim.keymap.set("n", "<leader>rg", vim.lsp.buf.definition, { desc = "Review: go to definition" })

-- Telescope: file/grep search
vim.keymap.set("n", "<leader>rf", function()
	require("telescope.builtin").git_files()
end, { desc = "Review: git files" })

vim.keymap.set("n", "<leader>r/", function()
	require("telescope.builtin").live_grep()
end, { desc = "Review: live grep" })

vim.keymap.set("n", "<leader>rgc", function()
	require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Review: grep word" })
