vim.pack.add({
	{ src = "/Users/tien-duy.nguyen/projects/oss/git/codememono/codeme.nvim" },
})

require("codeme").setup()

vim.keymap.set("n", "<leader>cm", "<cmd>CodeMe<cr>", { desc = "Open CodeMe Dashboard" })
vim.keymap.set("n", "<leader>uc", "<cmd>CodeMeToggle<cr>", { desc = "Toggle CodeMe" })
