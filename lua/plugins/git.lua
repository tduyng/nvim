vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/sindrets/diffview.nvim",
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

-- Setup diffview.nvim
require("diffview").setup({
	use_icons = true,
	icons = { folder_closed = "", folder_open = "" },
	view = {
		default = { winbar_info = true },
	},
	file_panel = {
		win_config = { height = 20 },
	},
})

-- diffview keymaps
vim.keymap.set("n", "<leader>Do", function()
	vim.ui.input({ prompt = "Diff refs (ex. main..feature): " }, function(refs)
		if refs and refs:match("%S") then
			local safe = vim.fn.shellescape(refs, true)
			vim.cmd(("DiffviewOpen %s"):format(safe))
		else
			vim.cmd("DiffviewOpen")
		end
	end)
end, { desc = "Diffview: open (prompt for refs or default)" })

vim.keymap.set("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: Close" })
vim.keymap.set("n", "<leader>Dt", "<cmd>DiffviewToggleFiles<cr>", { desc = "Diffview: Toggle file list" })
vim.keymap.set("n", "<leader>Dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: File history" })
vim.keymap.set("n", "<leader>DH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: Repo history" })

-- toggles
vim.keymap.set("n", "<leader>uG", function()
	local gs = require("gitsigns")
	local cfg = require("gitsigns.config").config
	local current = cfg.signcolumn
	gs.toggle_signs(not current)
end, { desc = "Toggle Git Signs" })
