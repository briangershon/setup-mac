local function git_ref_exists(ref)
	vim.fn.system("git rev-parse --verify " .. ref .. " 2>/dev/null")
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

local function get_merge_base(base)
	local merge_base = vim.fn.system("git merge-base HEAD " .. base):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 or merge_base == "" then
		return nil
	end
	return merge_base
end

require("gitsigns").setup({
	linehl = true,
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		-- Navigation
		map("n", "]h", gs.next_hunk, "Next git hunk")
		map("n", "[h", gs.prev_hunk, "Prev git hunk")

		-- Actions
		map("n", "<leader>hs", gs.stage_hunk, "[H]unk [S]tage")
		map("n", "<leader>hr", gs.reset_hunk, "[H]unk [R]eset")
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "[H]unk [S]tage (visual)")
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "[H]unk [R]eset (visual)")
		map("n", "<leader>hS", gs.stage_buffer, "[H]unk [S]tage buffer")
		map("n", "<leader>hu", gs.undo_stage_hunk, "[H]unk [U]ndo stage")
		map("n", "<leader>hR", gs.reset_buffer, "[H]unk [R]eset buffer")
		map("n", "<leader>hp", gs.preview_hunk, "[H]unk [P]review")
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, "[H]unk [B]lame line")
		map("n", "<leader>hd", gs.diffthis, "[H]unk [D]iff")
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, "[H]unk [D]iff against last commit")
		map("n", "<leader>tb", gs.toggle_current_line_blame, "[T]oggle line [B]lame")
		map("n", "<leader>td", gs.toggle_deleted, "[T]oggle show [D]eleted")

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
	end,
})

-- nord.nvim defines GitSigns*Ln highlights with fg only (no background),
-- which shadows gitsigns' own fallback to DiffAdd/DiffChange/DiffDelete and
-- makes `linehl` invisible. Link them to the Diff groups so linehl shows up.
vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })

vim.api.nvim_create_user_command("GitSignsMergeBase", function()
	local review_base = get_review_base()
	local merge_base = get_merge_base(review_base)
	if not merge_base then
		vim.notify("Could not find merge base with " .. review_base, vim.log.levels.ERROR)
		return
	end
	vim.cmd("Gitsigns change_base " .. merge_base)
end, {})

local function open_review()
	local review_base = get_review_base()
	local merge_base = get_merge_base(review_base)
	if not merge_base then
		vim.notify("Could not find merge base with " .. review_base, vim.log.levels.WARN)
		return
	end

	require("gitsigns").change_base(merge_base, true)

	local toplevel = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")
	local files_raw = vim.fn.system("git diff --name-only " .. merge_base .. " HEAD")
	if vim.v.shell_error ~= 0 then
		vim.notify("Could not list changed files against " .. review_base, vim.log.levels.WARN)
		return
	end

	local files = {}
	for file in files_raw:gmatch("[^\r\n]+") do
		table.insert(files, toplevel .. "/" .. file)
	end

	if #files == 0 then
		vim.notify("No changed files against " .. review_base, vim.log.levels.INFO)
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

vim.keymap.set("n", "<leader>gr", open_review, { desc = "Git: Review - open changed files vs base branch" })
