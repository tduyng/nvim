local M = {}

local SEP = "" -- separator glyph at buffer boundary
local CLOSE = "" -- close icon shown on active buffer
local NO_NAME = "[NO NAME]"

function M.set_highlights()
	vim.api.nvim_set_hl(0, "MyBufInactive", { fg = "#ABB2BF", bg = "#282C34" })
	vim.api.nvim_set_hl(0, "MyBufActive", { fg = "#ECEFF4", bg = "#3E4451", bold = true })
	vim.api.nvim_set_hl(0, "MyBufSeparator", { fg = "#21252B", bg = "#282C34" })
	vim.api.nvim_set_hl(0, "MyBufClose", { fg = "#BF616A", bg = "#3E4451" })
end

-- Safe devicons resolve (cached per render)
local function get_icon(filename, name)
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok or not name or name == "" then
		return ""
	end
	local ext = vim.fn.fnamemodify(name, ":e")
	local icon = devicons.get_icon(filename, ext, { default = true })
	return icon and (icon .. " ") or ""
end

-- Render a single buffer chunk
local function render_buf(bufnr, current)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return ""
	end
	if not vim.bo[bufnr].buflisted then
		return ""
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	local filename = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or NO_NAME
	local icon = get_icon(filename, name)
	local content = icon .. filename

	if bufnr == current then
		return table.concat({
			"%#MyBufActive# ",
			content,
			" %#MyBufClose#",
			CLOSE,
			" %#MyBufSeparator#",
			SEP,
		})
	else
		return table.concat({
			"%#MyBufInactive# ",
			content,
			"  %#MyBufSeparator#",
			SEP,
		})
	end
end

function M.tabline()
	local current = vim.api.nvim_get_current_buf()
	local parts = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local chunk = render_buf(bufnr, current)
		if chunk ~= "" then
			table.insert(parts, chunk)
		end
	end

	if #parts == 0 then
		return ""
	end
	return table.concat(parts):gsub(vim.pesc(SEP) .. "$", "")
end

function _G.tabline()
	local current = vim.api.nvim_get_current_buf()
	local parts = {}

	-- Iterate listed buffers in ascending handle order for stability
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local chunk = render_buf(bufnr, current)
		if chunk ~= "" then
			table.insert(parts, chunk)
		end
	end

	if #parts == 0 then
		return ""
	end

	local line = table.concat(parts)
	-- Trim trailing separator if present
	return line:gsub(vim.pesc(SEP) .. "$", "")
end

function M.setup()
	M.set_highlights()

	vim.api.nvim_create_augroup("MyTabline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "MyTabline",
		callback = M.set_highlights,
	})

	vim.opt.showtabline = 2
	vim.opt.tabline = "%!v:lua.tabline()"
end

-- Close all buffers to the left/right of the current one
vim.keymap.set("n", "<leader>bl", function()
	local cur = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf < cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all left buffers" })

vim.keymap.set("n", "<leader>br", function()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = vim.api.nvim_list_bufs()
	for i = #bufs, 1, -1 do
		local buf = bufs[i]
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf > cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all right buffers" })

M.setup()
