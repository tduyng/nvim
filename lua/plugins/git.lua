vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"/Users/tien-duy.nguyen/projects/oss/git/nixhub/apps/vdiff.nvim",
})

-- Setup gitsigns.nvim
require("gitsigns").setup({
	current_line_blame = true,
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
	on_attach = function(buffer)
		local gs = package.loaded.gitsigns

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
		end

		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end, "Next Hunk")

		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, "Prev Hunk")

		map("n", "]H", function()
			gs.nav_hunk("last")
		end, "Last Hunk")
		map("n", "[H", function()
			gs.nav_hunk("first")
		end, "First Hunk")

		map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
		map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

		map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
		map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
		map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
		map("n", "<leader>ghb", function()
			gs.blame_line({ full = true })
		end, "Blame Line")
		map("n", "<leader>ghB", function()
			gs.blame()
		end, "Blame Buffer")
		map("n", "<leader>ghd", gs.diffthis, "Diff This")
		map("n", "<leader>ghD", function()
			gs.diffthis("~")
		end, "Diff This ~")

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
	end,
})

-- Setup vdiff.nvim with side-by-side layout (IntelliJ style)
require("vdiff").setup({
	diff_layout = "diff2_vertical", -- side-by-side
	merge_layout = "diff3_vertical", -- 3-way side-by-side
})

-- Accepts any ref: branch, commit, tag, HEAD~N, or empty for working tree
-- Empty or nil = working tree vs HEAD
-- --staged = staged changes
-- main = compare with main branch
-- HEAD~3 = compare with 3 commits ago
-- abc123 = compare with commit hash
-- v1.0.0 = compare with tag
vim.keymap.set("n", "<leader>gc", function()
	vim.ui.input({
		prompt = "Compare with (branch/commit/tag/HEAD~N, empty=working): ",
	}, function(ref)
		vim.cmd("VDiffCompare " .. (ref or ""))
	end)
end, { desc = "Git: compare (universal)" })

-- Quick shortcuts for common comparisons
vim.keymap.set("n", "<leader>gd", "<Cmd>VDiffCompare<CR>", { desc = "Git: working tree (all files)" })
vim.keymap.set("n", "<leader>gD", "<Cmd>VDiffCompare --staged<CR>", { desc = "Git: staged (all files)" })
vim.keymap.set("n", "<leader>gV", "<Cmd>VDiffHistory<CR>", { desc = "Git: file history" })
vim.keymap.set("v", "<leader>gv", ":'<,'>VDiffRange<CR>", { desc = "Git: line history" })
vim.keymap.set("n", "<leader>gx", "<Cmd>VDiffClose<CR>", { desc = "Git: close all" })
-- 3-way merge view (LOCAL | RESULT | REMOTE)
vim.keymap.set("n", "<leader>gm", "<Cmd>VMerge<CR>", { desc = "Git: merge conflicts" })

-- CURRENT FILE DIFF
-- Same principle: accepts any ref or empty for HEAD
vim.keymap.set("n", "<leader>gf", "<Cmd>VDiff<CR>", { desc = "Git: diff file vs HEAD" })
vim.keymap.set("n", "<leader>gF", function()
	vim.ui.input({ prompt = "Diff file with (ref, empty=HEAD): " }, function(ref)
		vim.cmd("VDiff " .. (ref or ""))
	end)
end, { desc = "Git: diff file (universal)" })

-- UTILITY: Compare two arbitrary files (not git-related)
vim.keymap.set("n", "<leader>g2", function()
	vim.ui.input({ prompt = "First file: " }, function(file1)
		if not file1 or not file1:match("%S") then
			return
		end
		vim.ui.input({ prompt = "Second file: " }, function(file2)
			if file2 and file2:match("%S") then
				vim.cmd(("tabnew | e %s | diffthis | vsplit %s | diffthis"):format(file1, file2))
			end
		end)
	end)
end, { desc = "Git: compare 2 files" })
