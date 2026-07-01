require("gitsigns").setup({
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

vim.api.nvim_create_user_command("GitSignsMergeBase", function()
	-- Try local symref first (fast, no network)
	local remote_head = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null"):gsub("%s+$", "")
	local base_ref
	if vim.v.shell_error == 0 and remote_head ~= "" then
		base_ref = remote_head:gsub("^refs/remotes/", "")
	else
		-- Fall back to asking the remote (network call)
		local branch = vim.fn.system("git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}'"):gsub("%s+$", "")
		if vim.v.shell_error ~= 0 or branch == "" then
			vim.notify("Could not determine origin's default branch", vim.log.levels.ERROR)
			return
		end
		base_ref = "origin/" .. branch
	end

	local base = vim.fn.system("git merge-base HEAD " .. base_ref):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 or base == "" then
		vim.notify("Could not find merge base with " .. base_ref, vim.log.levels.ERROR)
		return
	end
	vim.cmd("Gitsigns change_base " .. base)
end, {})
