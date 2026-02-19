vim.pack.add({
	{ src = "~/projects/oss/git/codememono/codeme.nvim" },
})

require("codeme").setup({
	ignores = {
		-- Stops tracking future data
		tracking = {
			projects = {},
		},
		-- Hides existing data from the UI immediately
		dashboard = {
			projects = { "hodor*", "urba*", "whitelabel*" },
			files = { "hodor*", "urba*", "whitelabel*" },
			languages = { "gitignore", "gitconfig", "sshconfig" },
		},
	},
})

vim.keymap.set("n", "<leader>cm", "<cmd>CodeMe<cr>", { desc = "Open CodeMe Dashboard" })
vim.keymap.set("n", "<leader>uc", "<cmd>CodeMeToggle<cr>", { desc = "Toggle CodeMe" })
