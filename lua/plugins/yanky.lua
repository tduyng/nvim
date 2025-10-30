vim.pack.add({
	"https://github.com/gbprod/yanky.nvim",
})

local _yanky_loaded = false

local function load_yanky()
	if _yanky_loaded then
		return
	end
	_yanky_loaded = true

	require("yanky").setup({
		highlight = { timer = 150 },
	})
end

local group = vim.api.nvim_create_augroup("YankyLazyLoad", { clear = true })

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		load_yanky()
	end,
})

-- stylua: ignore start
vim.keymap.set({ "n", "x" }, "<leader>y", function()
	load_yanky()
	require("snacks").picker.yanky()
end, { desc = "Yank history" })

vim.keymap.set({ "n", "x" }, "y", function()
	load_yanky()
	return "<Plug>(YankyYank)"
end, { expr = true, desc = "Yank" })

vim.keymap.set({ "n", "x" }, "p", function()
	load_yanky()
	return "<Plug>(YankyPutAfter)"
end, { expr = true, desc = "Put after" })

vim.keymap.set({ "n", "x" }, "P", function()
	load_yanky()
	return "<Plug>(YankyPutBefore)"
end, { expr = true, desc = "Put before" })

vim.keymap.set({ "n", "x" }, "gp", function()
	load_yanky()
	return "<Plug>(YankyGPutAfter)"
end, { expr = true, desc = "Put after (selection)" })

vim.keymap.set({ "n", "x" }, "gP", function()
	load_yanky()
	return "<Plug>(YankyGPutBefore)"
end, { expr = true, desc = "Put before (selection)" })

vim.keymap.set("n", "<C-n>", function()
	load_yanky()
	return "<Plug>(YankyNextEntry)"
end, { expr = true, desc = "Next yank" })

vim.keymap.set("n", "<C-p>", function()
	load_yanky()
	return "<Plug>(YankyPreviousEntry)"
end, { expr = true, desc = "Prev yank" })

vim.keymap.set("n", "<leader>pi", function()
	load_yanky()
	return "<Plug>(YankyPutIndentAfterLinewise)"
end, { expr = true, desc = "Put indent after (line)" })

vim.keymap.set("n", "<leader>pI", function()
	load_yanky()
	return "<Plug>(YankyPutIndentBeforeLinewise)"
end, { expr = true, desc = "Put indent before (line)" })

vim.keymap.set("n", "<leader>pr", function()
	load_yanky()
	return "<Plug>(YankyPutIndentAfterShiftRight)"
end, { expr = true, desc = "Put & shift right" })

vim.keymap.set("n", "<leader>pl", function()
	load_yanky()
	return "<Plug>(YankyPutIndentAfterShiftLeft)"
end, { expr = true, desc = "Put & shift left" })

vim.keymap.set("n", "<leader>pf", function()
	load_yanky()
	return "<Plug>(YankyPutAfterFilter)"
end, { expr = true, desc = "Put after filter" })
