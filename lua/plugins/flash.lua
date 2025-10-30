vim.pack.add({
	"https://github.com/folke/flash.nvim",
})

local flash = require("flash")
flash.setup()

-- stylua: ignore start
vim.keymap.set({"n","x","o"}, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({"n","x","o"}, "S", function() flash.treesitter() end, { desc = "Flash" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Treesitter search" })
vim.keymap.set({"x","o"}, "S", function() flash.treesitter_search() end, { desc = "Flash" })
vim.keymap.set("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash search" })
-- stylua: ignore end
